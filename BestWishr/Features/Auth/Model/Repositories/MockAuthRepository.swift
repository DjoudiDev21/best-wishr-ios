import Foundation

final class MockAuthRepository: AuthRepositoryProtocol {
    
    private let mockUsers: [String: String] = [
        "user@example.com": "password123",
        "admin@example.com": "admin123",
        "test@test.com": "test123"
    ]
    
    func login(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Validate email format
        guard email.contains("@") else {
            throw AuthError.invalidEmail
        }
        
        // Validate password length
        guard password.count >= 6 else {
            throw AuthError.invalidPassword
        }
        
        // Check if user exists and password is correct
        guard let storedPassword = mockUsers[email.lowercased()],
              storedPassword == password else {
            throw AuthError.invalidCredentials
        }
        
        // Return successful user
        return User(
            id: UUID().uuidString,
            email: email.lowercased(),
            token: "mock_token_\(UUID().uuidString)"
        )
    }
    
    func register(email: String, password: String, firstName: String, lastName: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Validate email format
        guard email.contains("@") else {
            throw AuthError.invalidEmail
        }
        
        // Validate password length
        guard password.count >= 6 else {
            throw AuthError.invalidPassword
        }
        
        // Validate names
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AuthError.invalidName
        }
        
        // Check if user already exists
        if mockUsers[email.lowercased()] != nil {
            throw AuthError.userAlreadyExists
        }
        
        // Return successful registration
        return User(
            id: UUID().uuidString,
            email: email.lowercased(),
            token: "mock_token_\(UUID().uuidString)"
        )
    }
    
    func forgotPassword(email: String) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Validate email format
        guard email.contains("@") else {
            throw AuthError.invalidEmail
        }
        
        // In a real app, this would send an email
        // For mock, we just succeed
        print("📧 Mock: Password reset email sent to \(email)")
    }
}

enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case invalidName
    case invalidCredentials
    case userAlreadyExists
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password must be at least 6 characters long"
        case .invalidName:
            return "Please enter your first and last name"
        case .invalidCredentials:
            return "Invalid email or password"
        case .userAlreadyExists:
            return "An account with this email already exists"
        case .networkError:
            return "Network connection error"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}