import Foundation
import Combine

enum ResendRequestType {
    case emailVerification(email: String)
    case forgotPassword(email: String)
    
    var email: String {
        switch self {
        case .emailVerification(let email),
             .forgotPassword(let email):
            return email
        }
    }
}

class ResendNotificationCenter: ObservableObject {
    static let shared = ResendNotificationCenter()
    
    @Published var isLoading = false
    @Published var isSuccess = false
    
    private let resendSubject = PassthroughSubject<ResendRequestType, Never>()
    private let dismissSubject = PassthroughSubject<Void, Never>()
    
    var resendPublisher: AnyPublisher<ResendRequestType, Never> {
        resendSubject.eraseToAnyPublisher()
    }
    
    var dismissPublisher: AnyPublisher<Void, Never> {
        dismissSubject.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func requestResend(_ requestType: ResendRequestType) {
        resendSubject.send(requestType)
    }
    
    // Convenience method for backward compatibility
    func requestResend(email: String) {
        resendSubject.send(.emailVerification(email: email))
    }
    
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
        }
    }
    
    func setSuccess(_ success: Bool) {
        DispatchQueue.main.async {
            self.isSuccess = success
            if success {
                // Auto-dismiss banner after 3 seconds of success state
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isSuccess = false
                    self.dismissSubject.send(())
                }
            }
        }
    }
}
