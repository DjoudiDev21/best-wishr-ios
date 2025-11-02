import Foundation

final class HttpAuthRepository: AuthRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    
    init(httpClient:HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    func login(email: String, password: String) async throws -> User {
        let body = LoginRequestDto(email: email, password: password)
        let response: LoginResponseDto = try await httpClient.post(.authLogin, body: body)
        return User(id: response.id, email: response.email, token: response.token)
    }
}
