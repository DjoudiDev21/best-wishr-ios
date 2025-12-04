import Foundation

class MarkGiftAsPurchasedUseCase {
    private let repository: GiftRepositoryProtocol
    
    init(repository: GiftRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(giftId: String) async throws -> Gift {
        return try await repository.togglePurchased(giftId: giftId)
    }
}