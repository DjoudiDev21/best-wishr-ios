import Foundation
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published var authStore: AuthStore
    @Published var contactsStore: ContactsStore
    @Published var eventsStore: EventsStore
    @Published var giftsStore: GiftsStore
    @Published var isAuthenticated: Bool = false
    @Published var isInitializing: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Initialize authStore with environment-based repository
        let authRepository = Self.createAuthRepository()
        let loginUseCase = LoginUseCase(repository: authRepository)
        let registerUseCase = RegisterUseCase(repository: authRepository)
        let verifyEmailUseCase = VerifyEmailUseCase(repository: authRepository)
        let resendVerificationUseCase = ResendVerificationUseCase(repository: authRepository)
        let logoutUseCase = LogoutUseCase(repository: authRepository)
        let forgotPasswordUseCase = ForgotPasswordUseCase(repository: authRepository)
        let resetPasswordUseCase = ResetPasswordUseCase(repository: authRepository)
        let appleAuthUseCase = AppleAuthUseCase(repository: authRepository)
        let authPresenter = AuthPresenter(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            verifyEmailUseCase: verifyEmailUseCase,
            resendVerificationUseCase: resendVerificationUseCase,
            logoutUseCase: logoutUseCase,
            forgotPasswordUseCase: forgotPasswordUseCase,
            resetPasswordUseCase: resetPasswordUseCase,
            appleAuthUseCase: appleAuthUseCase
        )
        let authStore = AuthStore(presenter: authPresenter)
        self.authStore = authStore
        
        // Initialize contactsStore
        let contactsRepository = Self.createContactsRepository(
            tokenProvider: { authStore.tokens?.accessToken },
            userIdProvider: { authStore.user?.id }
        )
        let getContactsUseCase = GetContactsUseCase(repository: contactsRepository)
        let createContactUseCase = CreateContactUseCase(repository: contactsRepository)
        let updateContactUseCase = UpdateContactUseCase(repository: contactsRepository)
        let deleteContactUseCase = DeleteContactUseCase(repository: contactsRepository)
        let contactsPresenter = ContactsPresenter(
            getContactsUseCase: getContactsUseCase,
            createContactUseCase: createContactUseCase,
            updateContactUseCase: updateContactUseCase,
            deleteContactUseCase: deleteContactUseCase
        )
        self.contactsStore = ContactsStore(presenter: contactsPresenter)
        
        // Initialize eventsStore
        let eventsRepository = Self.createEventsRepository(
            tokenProvider: { authStore.tokens?.accessToken },
            userIdProvider: { authStore.user?.id }
        )
        let getEventsUseCase = GetEventsUseCase(repository: eventsRepository)
        let createEventUseCase = CreateEventUseCase(repository: eventsRepository)
        let deleteEventUseCase = DeleteEventUseCase(repository: eventsRepository)
        let eventsPresenter = EventsPresenter(
            getEventsUseCase: getEventsUseCase,
            createEventUseCase: createEventUseCase,
            deleteEventUseCase: deleteEventUseCase
        )
        self.eventsStore = EventsStore(presenter: eventsPresenter)
        
        // Initialize giftsStore
        let giftsRepository = Self.createGiftsRepository { 
            authStore.tokens?.accessToken
        }
        let generateGiftSuggestionsUseCase = GenerateGiftSuggestionsUseCase(repository: giftsRepository)
        let saveGiftToWishlistUseCase = SaveGiftToWishlistUseCase(repository: giftsRepository)
        let getSavedGiftsUseCase = GetSavedGiftsUseCase(repository: giftsRepository)
        let markGiftAsPurchasedUseCase = MarkGiftAsPurchasedUseCase(repository: giftsRepository)
        let giftsPresenter = GiftsPresenter(
            generateGiftSuggestionsUseCase: generateGiftSuggestionsUseCase,
            saveGiftToWishlistUseCase: saveGiftToWishlistUseCase,
            getSavedGiftsUseCase: getSavedGiftsUseCase,
            markGiftAsPurchasedUseCase: markGiftAsPurchasedUseCase
        )
        self.giftsStore = GiftsStore(presenter: giftsPresenter)
        
        // Set up observers after all stores are initialized
        observeAuthChanges()
        observeContactsChanges()
        observeEventsChanges()
        observeGiftsChanges()
    }
    
    private static let baseURL: URL = {
        let envURL = ProcessInfo.processInfo.environment["BACKEND_URL"]
        let bundleURL = Bundle.main.object(forInfoDictionaryKey: "BACKEND_URL") as? String
        let urlString = envURL ?? bundleURL ?? "https://api.example.com"
        
        return URL(string: urlString)!
    }()
    
    private static func createAuthRepository() -> AuthRepositoryProtocol {
        let httpClient = HttpClient(baseURL: baseURL)
        return HttpAuthRepository(httpClient: httpClient)
    }
    
    private static func createContactsRepository(
        tokenProvider: @escaping () -> String?,
        userIdProvider: @escaping () -> String?
    ) -> ContactRepositoryProtocol {
        let httpClient = HttpClient(baseURL: baseURL, tokenProvider: tokenProvider)
        return HttpContactRepository(httpClient: httpClient, userIdProvider: userIdProvider)
    }
    
    private static func createEventsRepository(
        tokenProvider: @escaping () -> String?,
        userIdProvider: @escaping () -> String?
    ) -> EventRepositoryProtocol {
        let httpClient = HttpClient(baseURL: baseURL, tokenProvider: tokenProvider)
        return HttpEventRepository(httpClient: httpClient, userIdProvider: userIdProvider)
    }
    
    private static func createGiftsRepository(
        tokenProvider: @escaping () -> String?
    ) -> GiftRepositoryProtocol {
        let httpClient = HttpClient(baseURL: baseURL, tokenProvider: tokenProvider)
        return HttpGiftRepository(httpClient: httpClient)
    }

    private func observeAuthChanges() {
        authStore.$isAuthenticated
            .sink { [weak self] authenticated in
                self?.isAuthenticated = authenticated
                if authenticated {
                    // User just authenticated - preload essential data
                    Task {
                        await self?.preloadEssentialData()
                    }
                } else {
                    // User logged out - reset stores
                    // self?.contactsStore.reset()
                    // self?.eventsStore.reset()
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
    
    private func observeGiftsChanges() {
        // Forward giftsStore changes to trigger AppStore UI updates
        giftsStore.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Cross-Store Computed Properties
    
    /// Comprehensive stats that combine data from multiple stores
    var appStats: AppStats {
        let upcomingEvents = eventsStore.events.filter { $0.date > Date() }
        
        return AppStats(
            contactsCount: contactsStore.contacts.count,
            upcomingEventsCount: upcomingEvents.count,
            thisMonthBirthdaysCount: contactsStore.contactStats.thisMonthCount,
            totalEventsCount: eventsStore.events.count,
            isDataLoaded: !contactsStore.contacts.isEmpty || !eventsStore.events.isEmpty
        )
    }
    
    // MARK: - Data Preloading
    
    private func preloadEssentialData() async {
        // Only preload if user is authenticated
        guard isAuthenticated else { return }
        
        isInitializing = true
        
        await withTaskGroup(of: Void.self) { group in
            // Load contacts (essential for event creation and contact picker)
            group.addTask { [weak self] in
                await self?.contactsStore.loadContacts()
            }
            
            // Load recent events (last 30 days + next 30 days)
            group.addTask { [weak self] in
                await self?.loadRecentEvents()
            }
        }
        
        isInitializing = false
    }
    
    private func loadRecentEvents() async {
        // Load recent and upcoming events (60-day window)
        await eventsStore.loadRecentEvents()
    }
}

// MARK: - Supporting Types

struct AppStats {
    let contactsCount: Int
    let upcomingEventsCount: Int
    let thisMonthBirthdaysCount: Int
    let totalEventsCount: Int
    let isDataLoaded: Bool
    
    var hasUpcomingEvents: Bool {
        upcomingEventsCount > 0
    }
    
    var hasContacts: Bool {
        contactsCount > 0
    }
    
    var hasThisMonthBirthdays: Bool {
        thisMonthBirthdaysCount > 0
    }
}
