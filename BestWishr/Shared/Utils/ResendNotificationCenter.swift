import Foundation
import Combine

class ResendNotificationCenter: ObservableObject {
    static let shared = ResendNotificationCenter()
    
    @Published var isLoading = false
    @Published var isSuccess = false
    
    private let resendSubject = PassthroughSubject<String, Never>()
    private let dismissSubject = PassthroughSubject<Void, Never>()
    
    var resendPublisher: AnyPublisher<String, Never> {
        resendSubject.eraseToAnyPublisher()
    }
    
    var dismissPublisher: AnyPublisher<Void, Never> {
        dismissSubject.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func requestResend(email: String) {
        resendSubject.send(email)
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