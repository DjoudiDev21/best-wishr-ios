import Foundation

class MarkGiftAsPurchasedUseCase {
    private let repository: GiftRepository
    
    init(repository: GiftRepository) {
        self.repository = repository
    }
    
    func execute(giftId: String) async throws -> Gift {
        return try await repository.togglePurchased(giftId: giftId)
    }
}