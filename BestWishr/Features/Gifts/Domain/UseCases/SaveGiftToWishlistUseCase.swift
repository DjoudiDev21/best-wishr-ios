import Foundation

class SaveGiftToWishlistUseCase {
    private let repository: GiftRepository
    
    init(repository: GiftRepository) {
        self.repository = repository
    }
    
    func execute(gift: Gift) async throws -> Gift {
        return try await repository.saveToWishlist(gift)
    }
}