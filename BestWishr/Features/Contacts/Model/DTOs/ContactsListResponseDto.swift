import Foundation

struct ContactsListResponseDto: Decodable {
    let contacts: [ContactResponseDto]
}
