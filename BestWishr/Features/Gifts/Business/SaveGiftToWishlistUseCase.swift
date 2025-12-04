import Foundation

class SaveGiftToWishlistUseCase {
    private let repository: GiftRepositoryProtocol
    
    init(repository: GiftRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(gift: Gift) async throws -> Gift {
        return try await repository.saveToWishlist(gift)
    }
}