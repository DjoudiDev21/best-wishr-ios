import Foundation
import Combine

enum NotificationType {
    case success
    case info
    case warning
}

struct AppNotification {
    let message: String
    let type: NotificationType
    let duration: TimeInterval
    
    init(message: String, type: NotificationType, duration: TimeInterval = 3.0) {
        self.message = message
        self.type = type
        self.duration = duration
    }
}

protocol GlobalNotificationHandlerProtocol {
    var notificationSubject: PassthroughSubject<AppNotification, Never> { get }
    func showSuccess(_ message: String)
    func showSuccess(_ message: String, duration: TimeInterval)
    func showInfo(_ message: String)
    func showInfo(_ message: String, duration: TimeInterval)
    func showWarning(_ message: String)
    func showWarning(_ message: String, duration: TimeInterval)
}

final class GlobalNotificationHandler: GlobalNotificationHandlerProtocol, ObservableObject {
    static let shared = GlobalNotificationHandler()
    
    let notificationSubject = PassthroughSubject<AppNotification, Never>()
    @Published var currentNotification: AppNotification?
    @Published var isShowingNotification = false
    
    private var cancellables = Set<AnyCancellable>()
    private var dismissTask: Task<Void, Never>?
    
    private init() {
        setupBindings()
    }
    
    private func setupBindings() {
        notificationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.showNotification(notification)
            }
            .store(in: &cancellables)
    }
    
    func showSuccess(_ message: String) {
        showSuccess(message, duration: 3.0)
    }
    
    func showSuccess(_ message: String, duration: TimeInterval) {
        let notification = AppNotification(message: message, type: .success, duration: duration)
        notificationSubject.send(notification)
    }
    
    func showInfo(_ message: String) {
        showInfo(message, duration: 3.0)
    }
    
    func showInfo(_ message: String, duration: TimeInterval) {
        let notification = AppNotification(message: message, type: .info, duration: duration)
        notificationSubject.send(notification)
    }
    
    func showWarning(_ message: String) {
        showWarning(message, duration: 3.0)
    }
    
    func showWarning(_ message: String, duration: TimeInterval) {
        let notification = AppNotification(message: message, type: .warning, duration: duration)
        notificationSubject.send(notification)
    }
    
    private func showNotification(_ notification: AppNotification) {
        // Cancel any existing dismiss task
        dismissTask?.cancel()
        
        currentNotification = notification
        isShowingNotification = true
        
        // Auto-dismiss after duration
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(notification.duration * 1_000_000_000))
            
            await MainActor.run { [weak self] in
                if !Task.isCancelled {
                    self?.dismissNotification()
                }
            }
        }
    }
    
    func dismissNotification() {
        dismissTask?.cancel()
        isShowingNotification = false
        currentNotification = nil
    }
}
