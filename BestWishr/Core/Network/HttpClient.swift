import Foundation

protocol HttpClientProtocol {
    func get<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T
    func post<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T
}

final class HttpClient: HttpClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let errorHandler: GlobalErrorHandlerProtocol
    
    init(baseURL: URL, session: URLSession = .shared, errorHandler: GlobalErrorHandlerProtocol = GlobalErrorHandler.shared) {
        self.baseURL = baseURL
        self.session = session
        self.errorHandler = errorHandler
    }

    func get<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T {
        let request = try endpoint.makeRequest(baseURL: baseURL)
        let (data, response) = try await session.data(for: request)
        return try decodeResponse(data: data, response: response)
    }

    func post<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await session.data(for: request)
        return try decodeResponse(data: data, response: response)
    }

    private func decodeResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network("Invalid response")
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = httpResponse.statusCode
            var errorMessage = "Request failed"
            
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = errorData["message"] as? String {
                errorMessage = message
            }
            
            switch statusCode {
            case 401:
                throw AppError.authentication(errorMessage)
            case 400..<500:
                throw AppError.validation(errorMessage)
            case 500...:
                throw AppError.server(statusCode, errorMessage)
            default:
                throw AppError.network("Status code: \(statusCode)")
            }
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw AppError.decodingError("Failed to decode response: \(error.localizedDescription)")
        }
    }
}
