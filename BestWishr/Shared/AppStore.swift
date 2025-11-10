import Foundation
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published var authStore: AuthStore
    @Published var contactsStore: ContactsStore
    @Published var eventsStore: EventsStore
    @Published var isAuthenticated: Bool = false
    private var cancellables = Set<AnyCancellable>()

        init() {
            // Initialize authStore with environment-based repository
            let authRepository = Self.createAuthRepository()
            let loginUseCase = LoginUseCase(repository: authRepository)
            let registerUseCase = RegisterUseCase(repository: authRepository)
            let forgotPasswordUseCase = ForgotPasswordUseCase(repository: authRepository)
            let authPresenter = AuthPresenter(
                loginUseCase: loginUseCase, 
                registerUseCase: registerUseCase,
                forgotPasswordUseCase: forgotPasswordUseCase
            )
            self.authStore = AuthStore(presenter: authPresenter)
            
            // Initialize contactsStore
            let contactsRepository = Self.createContactsRepository()
            let getContactsUseCase = GetContactsUseCase(repository: contactsRepository)
            let createContactUseCase = CreateContactUseCase(repository: contactsRepository)
            let deleteContactUseCase = DeleteContactUseCase(repository: contactsRepository)
            let contactsPresenter = ContactsPresenter(
                getContactsUseCase: getContactsUseCase,
                createContactUseCase: createContactUseCase,
                deleteContactUseCase: deleteContactUseCase
            )
            self.contactsStore = ContactsStore(presenter: contactsPresenter)
            
            // Initialize eventsStore
            let eventsRepository = Self.createEventsRepository()
            let getEventsUseCase = GetEventsUseCase(repository: eventsRepository)
            let createEventUseCase = CreateEventUseCase(repository: eventsRepository)
            let deleteEventUseCase = DeleteEventUseCase(repository: eventsRepository)
            let eventsPresenter = EventsPresenter(
                getEventsUseCase: getEventsUseCase,
                createEventUseCase: createEventUseCase,
                deleteEventUseCase: deleteEventUseCase
            )
            self.eventsStore = EventsStore(presenter: eventsPresenter)
            
            observeAuthChanges()
            observeContactsChanges()
            observeEventsChanges()
        }
        
        private static func createAuthRepository() -> AuthRepositoryProtocol {
            #if DEBUG
            // Use mock repository in debug/development
            return MockAuthRepository()
            #else
            // Use real HTTP repository in production
            let httpClient = HttpClient(baseURL: URL(string: "https://api.example.com")!)
            return HttpAuthRepository(httpClient: httpClient)
            #endif
        }
        
        private static func createContactsRepository() -> ContactRepositoryProtocol {
            #if DEBUG
            // Use mock repository in debug/development
            return MockContactRepository()
            #else
            // Use real HTTP repository in production (TODO: implement when API is ready)
            return MockContactRepository()
            #endif
        }
        
        private static func createEventsRepository() -> EventRepositoryProtocol {
            #if DEBUG
            // Use mock repository in debug/development
            return MockEventRepository()
            #else
            // Use real HTTP repository in production (TODO: implement when API is ready)
            return MockEventRepository()
            #endif
        }

        private func observeAuthChanges() {
            authStore.$isAuthenticated
                .sink { [weak self] authenticated in
                    self?.isAuthenticated = authenticated
                    if !authenticated {
                        // Exemple : reset d'autres stores
                        // self?.contactsStore.reset()
                    }
                }
                .store(in: &cancellables)
        }
        
        private func observeContactsChanges() {
            // Forward contactsStore changes to trigger AppStore UI updates
            contactsStore.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
        
        private func observeEventsChanges() {
            // Forward eventsStore changes to trigger AppStore UI updates
            eventsStore.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
}
