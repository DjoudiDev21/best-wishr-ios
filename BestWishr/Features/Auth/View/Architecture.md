// MPBS Architecture Overview

/*
This project follows an MPBS architecture (Model, Presenter, Business/UseCase, Store) tailored for SwiftUI with Combine and async/await. It keeps responsibilities clearly separated and makes UI updates predictable and testable.

Layers at a Glance

- Model
  - Pure data types and API DTOs.
  - No framework dependencies.

- Presenter (AuthPresenter, …)
  - Orchestrates interactions between Use Cases and Stores.
  - Transforms raw results (domain or DTO) into view-ready state.
  - Handles mapping of errors to user-facing messages.

- Business / Use Case (LoginUseCase, …)
  - Encapsulates business rules and application logic.
  - Talks to repositories (e.g., `AuthRepository`) that access the API or persistence.
  - Returns domain results (success/ failure) to the presenter.

- Store (AuthStore, AppStore, …)
  - Source of truth for view state. Uses `@Published` properties.
  - Drives SwiftUI updates automatically.
  - Exposes intents the ViewModel can call (e.g., `login(email, password)`).

- ViewModel (LoginViewModel, …)
  - Binds UI interactions to Store/Presenter intents.
  - Keeps the View lightweight and declarative.

- View (SwiftUI)
  - Declares UI from `@Published` state.
  - Reacts automatically when the Store updates.

Login Flow Example

User Action (tap on "Login")
      ↓
`ViewModel.loginTapped()`
      ↓
`AuthStore.login(email, password)`
      ↓
`AuthPresenter.performLogin()`
      ↓
`LoginUseCase.execute()` → `AuthRepository` → API
      ↓
AuthPresenter transforms the result (domain → view state)
      ↓
`AuthStore` updates `@Published`
      ↓
SwiftUI View updates automatically

What each step does

1. View (SwiftUI)
   - The user taps the "Login" button.
   - The View calls a method on the ViewModel: `loginTapped()`.

2. ViewModel
   - Validates basic input if needed.
   - Forwards the intent to the store: `authStore.login(email, password)`.

3. AuthStore
   - Sets transient state (e.g., `isLoading = true`).
   - Delegates the operation to the presenter: `authPresenter.performLogin(email, password)`.

4. AuthPresenter
   - Calls the use case: `loginUseCase.execute(email, password)`.
   - Receives success/failure and maps it to a view-ready state.
   - Notifies the store with the transformed state.

5. LoginUseCase
   - Coordinates with `AuthRepository` to talk to the API.
   - Applies business rules (e.g., token handling, error normalization).
   - Returns a typed result (e.g., `LoginResult`).

6. AuthRepository
   - Performs the network request.
   - Maps API DTOs to domain models.

7. AuthStore (update)
   - Applies the presenter’s transformed state to its `@Published` properties
     (e.g., `isAuthenticated`, `user`, `errorMessage`, `isLoading`).

8. SwiftUI View
   - Reacts to `@Published` changes via `@ObservedObject` / `@EnvironmentObject`.
   - UI updates automatically with no manual refresh.

Example Pseudocode

```swift
// ViewModel
func loginTapped() {
    authStore.login(email: email, password: password)
}

// AuthStore
@Published var isLoading = false
@Published var isAuthenticated = false
@Published var errorMessage: String?

func login(email: String, password: String) {
    isLoading = true
    presenter.performLogin(email: email, password: password)
}

// AuthPresenter
func performLogin(email: String, password: String) {
    Task { @MainActor in
        do {
            let result = try await useCase.execute(email: email, password: password)
            // Transform result → view state
            store.errorMessage = nil
            store.isAuthenticated = result.isAuthenticated
        } catch {
            store.errorMessage = map(error)
            store.isAuthenticated = false
        }
        store.isLoading = false
    }
}

// LoginUseCase
func execute(email: String, password: String) async throws -> LoginResult {
    try await repository.login(email: email, password: password)
}
