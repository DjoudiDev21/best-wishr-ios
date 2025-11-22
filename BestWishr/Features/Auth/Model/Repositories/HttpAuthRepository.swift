import Foundation

final class HttpAuthRepository: AuthRepositoryProtocol {
    private let httpClient: HttpClientProtocol
    
    init(httpClient:HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    func login(email: String, password: String) async throws -> AuthSession {
        let body = LoginRequestDto(email: email, password: password)
        do {
            let response: LoginResponseDto = try await httpClient.post(.authLogin, body: body)
            let user = User(
                id: response.user.id, 
                email: response.user.email, 
                firstname: response.user.firstname, 
                lastname: response.user.lastname
            )
            let tokens = AuthTokens(
                accessToken: response.accessToken, 
                refreshToken: response.refreshToken
            )
            let session = AuthSession(user: user, tokens: tokens)
            return session
        } catch {
            throw error
        }
    }
    
    func register(email: String, password: String, firstname: String, lastname: String) async throws {
        let body = RegisterRequestDto(email: email, password: password, firstname: firstname, lastname: lastname)
        do {
            try await httpClient.postVoid(.authRegister, body: body)
        } catch {
            throw error
        }
    }
    
    func verifyEmail(token: String) async throws -> AuthSession {
        let body = VerifyEmailRequestDto(token: token)
        do {
            let response: VerifyEmailResponseDto = try await httpClient.post(.authVerifyEmail, body: body)
            let user = User(
                id: response.user.id, 
                email: response.user.email, 
                firstname: response.user.firstname, 
                lastname: response.user.lastname
            )
            let tokens = AuthTokens(
                accessToken: response.accessToken, 
                refreshToken: response.refreshToken
            )
            let session = AuthSession(user: user, tokens: tokens)
            return session
        } catch {
            throw error
        }
    }
    
    func resendVerificationEmail(email: String) async throws {
        print("📧 AuthRepository: Resending verification email to: \(email)")
        
        let body = SendEmailVerificationDto(email: email)
        do {
            let response: ResendVerificationResponseDto = try await httpClient.post(.authSendEmailVerification, body: body)
            print("✅ AuthRepository: Verification email sent successfully - \(response.message)")
        } catch {
            print("❌ AuthRepository: Failed to send verification email: \(error)")
            throw error
        }
    }
    
    func forgotPassword(email: String) async throws {
        // TODO: Implement when forgot password endpoint is available
        fatalError("Forgot password endpoint not implemented yet")
    }
    
    func appleAuth(request: AppleAuthRequestDto) async throws -> AuthSession {
        let body = SocialAuthRequestDto(
            provider: "APPLE",
            accessToken: request.identityToken,
            authorizationCode: request.authorizationCode,
            platform: "ios",
            redirectUri: nil
        )
        
        do {
            let response: SocialAuthResponseDto = try await httpClient.post(.authSocialMobile, body: body)
            let user = User(
                id: response.user.id,
                email: response.user.email,
                firstname: response.user.firstname,
                lastname: response.user.lastname
            )
            let tokens = AuthTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            let session = AuthSession(user: user, tokens: tokens)
            return session
        } catch {
            throw error
        }
    }
}
