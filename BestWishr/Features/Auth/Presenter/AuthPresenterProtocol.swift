import Foundation

protocol AuthPresenterProtocol {
     func performLogin(email: String, password: String) async -> Result<User, Error>
     func performRegister(email: String, password: String, firstName: String, lastName: String) async -> Result<User, Error>
     func performForgotPassword(email: String) async -> Result<Void, Error>
 }
