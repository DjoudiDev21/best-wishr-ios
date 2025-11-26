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
        let body = SendEmailVerificationDto(email: email)
        do {
            let _: ResendVerificationResponseDto = try await httpClient.post(.authSendEmailVerification, body: body)
        } catch {
            throw error
        }
    }
    
    func logout(refreshToken: String) async throws {
        let body = MobileLogoutDto(refreshToken: refreshToken)
        do {
            try await httpClient.postVoid(.authLogout, body: body)
        } catch {
            throw error
        }
    }
    
    func forgotPassword(email: String) async throws {
        let body = ForgotPasswordDto(email: email)
        do {
            try await httpClient.postVoid(.authForgotPassword, body: body)
        } catch {
            throw error
        }
    }
    
    func resetPassword(token: String, newPassword: String) async throws {
        let body = ResetPasswordDto(token: token, newPassword: newPassword)
        do {
            try await httpClient.postVoid(.authResetPassword, body: body)
        } catch {
            throw error
        }
    }
    
    func appleAuth(request: AppleAuthRequestDto) async throws -> AuthSession {
        print("🌐 HttpAuthRepository: Starting Apple auth request")
        print("🌐 HttpAuthRepository: Identity token: \(String(request.identityToken.prefix(50)))...")
        print("🌐 HttpAuthRepository: Authorization code: \(String(request.authorizationCode.prefix(20)))...")
        
        let body = SocialAuthRequestDto(
            provider: "APPLE",
            accessToken: request.identityToken,
            authorizationCode: request.authorizationCode,
            platform: "ios",
            redirectUri: nil
        )
        
        print("🌐 HttpAuthRepository: Created SocialAuthRequestDto with provider: \(body.provider), platform: \(body.platform)")
        
        do {
            print("🌐 HttpAuthRepository: Making HTTP POST request to .authSocialMobile")
            let response: SocialAuthResponseDto = try await httpClient.post(.authSocialMobile, body: body)
            print("🌐 HttpAuthRepository: HTTP request SUCCESS - user email: \(response.user.email)")
            
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
            print("🌐 HttpAuthRepository: Created AuthSession successfully")
            return session
        } catch {
            print("🌐 HttpAuthRepository: HTTP request FAILED - error: \(error.localizedDescription)")
            print("🌐 HttpAuthRepository: Error type: \(type(of: error))")
            throw error
        }
    }
}
