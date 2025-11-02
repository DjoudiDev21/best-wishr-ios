# BestWishr iOS Architecture

## Overview

BestWishr follows a **Model-Business-Presenter-Store (MBPS)** architecture pattern, which provides clear separation of concerns and excellent testability for iOS applications. This architecture combines the best aspects of Clean Architecture with SwiftUI's reactive programming model.

## Architecture Layers

### 1. Model Layer (`/Model`)
The Model layer contains data structures and business entities.

**Components:**
- **DTOs (Data Transfer Objects)**: Raw data structures for API communication
  - `LoginRequestDto.swift`
  - `LoginResponseDto.swift`
- **Entities**: Core business objects with validation logic
  - `User.swift`
- **Mappers**: Convert between DTOs and Entities
  - `UserMapper.swift`
- **Repository Protocols**: Define data access contracts
  - `AuthRepositoryProtocol.swift`
- **Repository Implementations**: Concrete data access implementations
  - `HttpAuthRepository.swift`

**Responsibilities:**
- Define data structures
- Handle data transformation
- Validate business rules
- Abstract data sources

### 2. Business Layer (`/Business`)
The Business layer contains use cases that orchestrate business logic.

**Components:**
- **Use Cases**: Encapsulate specific business operations
  - `LoginUseCase.swift`

**Responsibilities:**
- Execute business workflows
- Coordinate between repositories
- Apply business rules
- Return business results

### 3. Presenter Layer (`/Presenter`)
The Presenter layer handles presentation logic and coordinates between Business and View layers.

**Components:**
- **Presenters**: Transform business data for UI consumption
  - `AuthPresenter.swift`

**Responsibilities:**
- Convert business results to view-friendly data
- Handle presentation logic
- Coordinate async operations
- Bridge Business and Store layers

### 4. Store Layer (`/Store`)
The Store layer manages application state using SwiftUI's reactive programming model.

**Components:**
- **Stores**: Observable state containers
  - `AuthStore.swift`
  - `AppStore.swift`

**Responsibilities:**
- Manage UI state
- Handle user interactions
- Coordinate with Presenters
- Emit state changes to Views

### 5. View Layer (`/View`)
The View layer contains SwiftUI views and view models.

**Components:**
- **Views**: SwiftUI user interface components
  - `LoginScreen.swift`
  - `RegisterScreen.swift`
  - `HomeScreen.swift`
- **ViewModels**: View-specific state and logic
  - `AuthViewModel.swift`

**Responsibilities:**
- Render user interface
- Handle user input
- Observe store state
- Manage view-specific state

## Core Infrastructure

### Network Layer (`/Core/Network`)
Handles all HTTP communication with clean error handling.

**Components:**
- `HttpClient.swift`: Generic HTTP client with error mapping
- `ApiEndpoint.swift`: API endpoint definitions

**Features:**
- Automatic error mapping to `AppError`
- Generic request/response handling
- Configurable base URL and session

### Error Handling (`/Core/Error`)
Centralized error management system for consistent user experience.

**Components:**
- `AppError.swift`: Comprehensive error enumeration
- `GlobalErrorHandler.swift`: Centralized error processing
- `ErrorAlert.swift`: SwiftUI error display modifier

**Features:**
- Type-safe error categories
- User-friendly error messages
- Automatic retry logic detection
- Global error state management

## Data Flow

### Authentication Flow Example

```
1. User taps Login → LoginScreen
2. LoginScreen → AuthViewModel.login()
3. AuthViewModel → AuthStore.login()
4. AuthStore → AuthPresenter.performLogin()
5. AuthPresenter → LoginUseCase.execute()
6. LoginUseCase → AuthRepository.login()
7. AuthRepository → HttpClient.post()
8. HttpClient → API Server
9. Response flows back through the layers
10. AuthStore updates @Published state
11. UI automatically updates via SwiftUI bindings
```

### Error Flow Example

```
1. Network error occurs in HttpClient
2. HttpClient maps to AppError
3. Error propagates up to AuthStore
4. AuthStore passes to GlobalErrorHandler
5. GlobalErrorHandler publishes error
6. ErrorAlert modifier displays user-friendly message
7. User sees contextual error with retry option
```

## Key Benefits

### Separation of Concerns
- **Model**: Pure data and business logic
- **Business**: Orchestrated workflows
- **Presenter**: Presentation coordination
- **Store**: State management
- **View**: UI rendering

### Testability
- Each layer can be unit tested independently
- Dependencies are injected via protocols
- Business logic is isolated from UI framework
- Mock implementations for testing

### Maintainability
- Clear boundaries between responsibilities
- Consistent patterns across features
- Easy to locate and modify functionality
- Scalable architecture for team development

### SwiftUI Integration
- Reactive state management with `@Published`
- Automatic UI updates via Combine
- Clean separation of view and business logic
- Modern iOS development patterns

## Implementation Guidelines

### Adding New Features

1. **Define Models**: Create DTOs, Entities, and Repository protocols
2. **Implement Business Logic**: Create Use Cases for workflows
3. **Add Presenter**: Transform business data for UI
4. **Create Store**: Manage feature state with `@Published` properties
5. **Build Views**: Create SwiftUI views and ViewModels
6. **Handle Errors**: Ensure proper error handling through all layers

### Best Practices

- **Dependency Injection**: Use protocol-based dependency injection
- **Single Responsibility**: Each class should have one clear purpose
- **Immutable Data**: Prefer immutable data structures
- **Error Handling**: Always handle errors at appropriate layers
- **Testing**: Write unit tests for each layer independently
- **Documentation**: Document public interfaces and business logic

## Error Handling Strategy

### Error Categories
- **Network**: Connection and HTTP errors
- **Authentication**: Login and authorization failures
- **Validation**: Input validation errors
- **Server**: Backend service errors
- **Unknown**: Unexpected errors

### User Experience
- User-friendly error messages
- Contextual retry options
- Consistent error presentation
- Graceful degradation

## Future Considerations

- **Offline Support**: Add local storage layer
- **Caching**: Implement response caching strategy
- **Analytics**: Integrate analytics tracking
- **Internationalization**: Support multiple languages
- **Performance**: Optimize for larger datasets

This architecture provides a solid foundation for building maintainable, testable, and scalable iOS applications with SwiftUI and modern iOS development practices.