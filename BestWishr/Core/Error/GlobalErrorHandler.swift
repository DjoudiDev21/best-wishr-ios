import Foundation
import Combine

protocol GlobalErrorHandlerProtocol {
    var errorSubject: PassthroughSubject<AppError, Never> { get }
    func handle(_ error: Error)
    func handle(_ appError: AppError)
}

final class GlobalErrorHandler: GlobalErrorHandlerProtocol, ObservableObject {
    static let shared = GlobalErrorHandler()
    
    let errorSubject = PassthroughSubject<AppError, Never>()
    @Published var currentError: AppError?
    @Published var isShowingError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupBindings()
    }
    
    private func setupBindings() {
        errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.currentError = error
                self?.isShowingError = true
                self?.logError(error)
            }
            .store(in: &cancellables)
    }
    
    func handle(_ error: Error) {
        let appError = mapToAppError(error)
        handle(appError)
    }
    
    func handle(_ appError: AppError) {
        errorSubject.send(appError)
    }
    
    func dismissError() {
        isShowingError = false
        currentError = nil
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
        print("🚨 Global Error: \(error.localizedDescription)")
        
        #if DEBUG
        print("Error details: \(error)")
        #endif
    }
}