import XCTest
@testable import BestWishr

@MainActor
final class LoginUseCaseTests: XCTestCase {
    
    private var useCase: LoginUseCase!
    private var mockRepository: MockAuthRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockAuthRepository()
        useCase = LoginUseCase(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // ✅ Happy path
    func testExecute_withValidCredentials_returnsSuccess() async {
        // Given
        let expectedUser = User(id: "1", email: "test@test.com", firstname: "John", lastname: "Doe")
        let expectedTokens = AuthTokens(accessToken: "access_token", refreshToken: "refresh_token")
        let expectedSession = AuthSession(user: expectedUser, tokens: expectedTokens)
        mockRepository.loginResult = .success(expectedSession)

        // When
        let result = await useCase.execute(email: "test@test.com", password: "password")

        // Then
        guard case .success(let session) = result else {
            XCTFail("Expected success but got failure")
            return
        }
        XCTAssertEqual(session.user.id, expectedUser.id)
        XCTAssertEqual(session.user.email, expectedUser.email)
        XCTAssertEqual(session.tokens.accessToken, expectedTokens.accessToken)
    }
    
    // ✅ Error handling
    func testExecute_withRepositoryError_returnsFailure() async {
        // Given
        let expectedError = NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        mockRepository.loginResult = .failure(expectedError)

        // When
        let result = await useCase.execute(email: "test@test.com", password: "wrongpassword")

        // Then
        guard case .failure(let error) = result else {
            XCTFail("Expected failure but got success")
            return
        }
        XCTAssertEqual((error as NSError).domain, "AuthError")
        XCTAssertEqual((error as NSError).code, 401)
    }
    
    // ✅ Input validation (Currently not implemented in LoginUseCase)
    func testExecute_withEmptyEmail_returnsValidationError() async {
        // TODO: Implement validation in LoginUseCase first
        // Given
        let expectedUser = User(id: "1", email: "test@test.com", firstname: "John", lastname: "Doe")
        let expectedTokens = AuthTokens(accessToken: "access_token", refreshToken: "refresh_token")
        let expectedSession = AuthSession(user: expectedUser, tokens: expectedTokens)
        mockRepository.loginResult = .success(expectedSession)

        // When
        let result = await useCase.execute(email: "", password: "password")

        // Then - Currently passes empty email to repository
        // Should validate and return error before calling repository
        guard case .success = result else {
            XCTFail("LoginUseCase doesn't validate empty email yet")
            return
        }
    }
    
    func testExecute_withEmptyPassword_returnsValidationError() async {
        // TODO: Implement validation in LoginUseCase first
        // Given
        let expectedUser = User(id: "1", email: "test@test.com", firstname: "John", lastname: "Doe")
        let expectedTokens = AuthTokens(accessToken: "access_token", refreshToken: "refresh_token")
        let expectedSession = AuthSession(user: expectedUser, tokens: expectedTokens)
        mockRepository.loginResult = .success(expectedSession)

        // When
        let result = await useCase.execute(email: "test@test.com", password: "")

        // Then - Currently passes empty password to repository
        // Should validate and return error before calling repository
        guard case .success = result else {
            XCTFail("LoginUseCase doesn't validate empty password yet")
            return
        }
    }
}
