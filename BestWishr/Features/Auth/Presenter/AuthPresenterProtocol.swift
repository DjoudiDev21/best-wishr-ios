import Foundation

protocol AuthPresenterProtocol {
     func performLogin(email: String, password: String) async -> Result<User, Error>
 }
