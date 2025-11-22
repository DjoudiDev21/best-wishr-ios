import Foundation
import Combine

enum ErrorPresentationMode {
    case alert          // Traditional alert dialog
    case banner         // Persistent banner (for verification issues)
    case toast          // Brief toast message
    case silent         // Log only, no UI
}

struct ErrorPresentation {
    let error: AppError
    let mode: ErrorPresentationMode
    let context: [String: Any]?
    
    init(error: AppError, mode: ErrorPresentationMode, context: [String: Any]? = nil) {
        self.error = error
        self.mode = mode
        self.context = context
    }
}

protocol GlobalErrorHandlerProtocol {
    var errorSubject: PassthroughSubject<ErrorPresentation, Never> { get }
    func handle(_ error: Error)
    func handle(_ appError: AppError)
    func handle(_ error: Error, presentationMode: ErrorPresentationMode, context: [String: Any]?)
    func handle(_ appError: AppError, presentationMode: ErrorPresentationMode, context: [String: Any]?)
}

final class GlobalErrorHandler: GlobalErrorHandlerProtocol, ObservableObject {
    static let shared = GlobalErrorHandler()
    
    let errorSubject = PassthroughSubject<ErrorPresentation, Never>()
    @Published var currentError: AppError?
    @Published var isShowingError = false
    @Published var currentPresentation: ErrorPresentation?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupBindings()
    }
    
    private func setupBindings() {
        errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] presentation in
                self?.currentPresentation = presentation
                
                // Handle based on presentation mode
                switch presentation.mode {
                case .alert:
                    self?.currentError = presentation.error
                    self?.isShowingError = true
                case .banner:
                    // Banner errors are handled by specific UI components
                    break
                case .toast:
                    // Toast errors could trigger a different UI element
                    break
                case .silent:
                    // Silent errors are only logged
                    break
                }
                
                self?.logError(presentation.error)
            }
            .store(in: &cancellables)
    }
    
    func handle(_ error: Error) {
        let appError = mapToAppError(error)
        handle(appError, presentationMode: .alert, context: nil)
    }
    
    func handle(_ appError: AppError) {
        handle(appError, presentationMode: .alert, context: nil)
    }
    
    func handle(_ error: Error, presentationMode: ErrorPresentationMode, context: [String: Any]?) {
        let appError = mapToAppError(error)
        handle(appError, presentationMode: presentationMode, context: context)
    }
    
    func handle(_ appError: AppError, presentationMode: ErrorPresentationMode, context: [String: Any]?) {
        let presentation = ErrorPresentation(error: appError, mode: presentationMode, context: context)
        errorSubject.send(presentation)
    }
    
    func dismissError() {
        isShowingError = false
        currentError = nil
        currentPresentation = nil
    }
    
    private func mapToAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternet
            case .timedOut:
                return .timeout
            default:
                return .network(urlError.localizedDescription)
            }
        }
        
        if error is DecodingError {
            return .decodingError("Failed to parse server response")
        }
        
        return .unknown(error.localizedDescription)
    }
    
    private func logError(_ error: AppError) {
        #if DEBUG
        print("Error details: \(error)")
        #endif
    }
}
