import Foundation
@testable import BestWishr

class MockHttpClient: HttpClientProtocol {
    var postResult: Result<Any, Error>!
    var getResult: Result<Any, Error>!
    
    func get<T>(_ endpoint: BestWishr.ApiEndpoint) async throws -> T where T : Decodable {
        switch getResult! {
        case .success(let data):
           return data as! T
        case .failure(let error):
           throw error
        }
    }
    
    func post<T, U>(_ endpoint: BestWishr.ApiEndpoint, body: U) async throws -> T where T : Decodable, U : Encodable {
        switch postResult! {
        case .success(let data):
            return data as! T
        case .failure(let error):
            throw error
        }
    }
}
