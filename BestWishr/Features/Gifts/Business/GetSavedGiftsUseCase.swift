import Foundation

class GetSavedGiftsUseCase {
    private let repository: GiftRepositoryProtocol
    
    init(repository: GiftRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Gift] {
        return try await repository.getWishlistedGifts()
    }
}