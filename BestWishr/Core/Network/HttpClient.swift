import Foundation

protocol HttpClientProtocol {
    func get<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T
    func post<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T
    func postVoid<U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws
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
        print("🌐 GET Request: \(request.url?.absoluteString ?? "Unknown URL")")
        print("📤 Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await session.data(for: request)
            print("📥 Response received: \(data.count) bytes")
            let result: T = try decodeResponse(data: data, response: response)
            print("✅ GET Success: \(type(of: result))")
            return result
        } catch {
            print("❌ GET Failed: \(error)")
            throw error
        }
    }

    func post<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("🌐 POST Request: \(request.url?.absoluteString ?? "Unknown URL")")
        print("📤 Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📤 Body: \(bodyString)")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            print("📥 Response received: \(data.count) bytes")
            let result: T = try decodeResponse(data: data, response: response)
            print("✅ POST Success: \(type(of: result))")
            return result
        } catch {
            print("❌ POST Failed: \(error)")
            throw error
        }
    }
    
    func postVoid<U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("🌐 POST (void) Request: \(request.url?.absoluteString ?? "Unknown URL")")
        print("📤 Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📤 Body: \(bodyString)")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            print("📥 Response received: \(data.count) bytes")
            try validateResponse(response: response, data: data)
            print("✅ POST (void) Success")
        } catch {
            print("❌ POST (void) Failed: \(error)")
            throw error
        }
    }

    private func validateResponse(response: URLResponse, data: Data? = nil) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network("Invalid response")
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = httpResponse.statusCode
            var errorMessage = "Request failed"
            
            // Try to extract detailed error message from response body
            if let data = data,
               let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let message = errorData["message"] as? String {
                    errorMessage = message
                } else if let messages = errorData["message"] as? [String] {
                    errorMessage = messages.joined(separator: ", ")
                }
            }
            
            print("🚨 HTTP Error \(statusCode): \(errorMessage)")
            
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
