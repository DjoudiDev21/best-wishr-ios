import Foundation
@testable import BestWishr

class MockAuthPresenter: AuthPresenterProtocol {
    var performLoginResult: Result<User, Error>!
    var performLoginCalled = false

    func performLogin(email: String, password: String) async -> Result<User, Error> {
        performLoginCalled = true
        return performLoginResult!
    }
}
