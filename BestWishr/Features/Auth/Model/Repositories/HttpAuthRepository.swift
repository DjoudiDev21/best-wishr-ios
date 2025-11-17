import Foundation

final class HttpAuthRepository: AuthRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    
    init(httpClient:HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    func login(email: String, password: String) async throws -> User {
        print("🔐 AuthRepository: Starting login for email: \(email)")
        
        let body = LoginRequestDto(email: email, password: password)
        do {
            let response: LoginResponseDto = try await httpClient.post(.authLogin, body: body)
            let user = User(id: response.id, email: response.email, token: response.token, firstname: response.firstname, lastname: response.lastname)
            print("✅ AuthRepository: Login successful for user: \(user.id)")
            return user
        } catch {
            print("❌ AuthRepository: Login failed for email \(email): \(error)")
            throw error
        }
    }
    
    func register(email: String, password: String, firstname: String, lastname: String) async throws {
        print("📝 AuthRepository: Starting registration for email: \(email)")
        
        let body = RegisterRequestDto(email: email, password: password, firstname: firstname, lastname: lastname)
        do {
            try await httpClient.postVoid(.authRegister, body: body)
            print("✅ AuthRepository: Registration successful for email: \(email)")
        } catch {
            print("❌ AuthRepository: Registration failed for email \(email): \(error)")
            throw error
        }
    }
    
    func verifyEmail(token: String) async throws -> Void {
        print("✉️ AuthRepository: Starting email verification with token")
        
        let body = VerifyEmailRequestDto(token: token)
        do {
            try await httpClient.postVoid(.authVerifyEmail, body: body)
            print("✅ AuthRepository: Email verification successful")
        } catch {
            print("❌ AuthRepository: Email verification failed: \(error)")
            throw error
        }
    }
    
    func forgotPassword(email: String) async throws {
        // TODO: Implement when forgot password endpoint is available
        fatalError("Forgot password endpoint not implemented yet")
    }
}
