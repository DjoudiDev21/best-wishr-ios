import Foundation
@testable import BestWishr

class MockAuthRepository: AuthRepositoryProtocol {
    var loginResult: Result<AuthSession, Error>!
    var registerResult: Result<Void, Error> = .success(())
    var verifyEmailResult: Result<AuthSession, Error>!
    var resendVerificationResult: Result<Void, Error> = .success(())
    var forgotPasswordResult: Result<Void, Error> = .success(())
    var appleAuthResult: Result<AuthSession, Error>!

    func login(email: String, password: String) async throws -> AuthSession {
        switch loginResult! {
        case .success(let session):
            return session
        case .failure(let error):
            throw error
        }
    }
    
    func register(email: String, password: String, firstname: String, lastname: String) async throws -> Void {
        switch registerResult {
        case .success():
            return
        case .failure(let error):
            throw error
        }
    }
    
    func verifyEmail(token: String) async throws -> AuthSession {
        switch verifyEmailResult! {
        case .success(let session):
            return session
        case .failure(let error):
            throw error
        }
    }
    
    func resendVerificationEmail(email: String) async throws {
        switch resendVerificationResult {
        case .success():
            return
        case .failure(let error):
            throw error
        }
    }
    
    func forgotPassword(email: String) async throws {
        switch forgotPasswordResult {
        case .success():
            return
        case .failure(let error):
            throw error
        }
    }
    
    func appleAuth(request: AppleAuthRequestDto) async throws -> AuthSession {
        switch appleAuthResult! {
        case .success(let session):
            return session
        case .failure(let error):
            throw error
        }
    }
}
