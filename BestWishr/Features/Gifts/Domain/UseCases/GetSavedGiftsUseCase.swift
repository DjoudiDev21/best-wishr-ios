import Foundation

class GetSavedGiftsUseCase {
    private let repository: GiftRepository
    
    init(repository: GiftRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Gift] {
        return try await repository.getWishlistedGifts()
    }
}