import Foundation

protocol HttpClientProtocol {
    func get<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T
    func post<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T
    func postVoid<U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws
    func put<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T
    func delete(_ endpoint: ApiEndpoint) async throws
}

final class HttpClient: HttpClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let errorHandler: GlobalErrorHandlerProtocol
    private let tokenProvider: () -> String?

    init(baseURL: URL, session: URLSession = .shared, errorHandler: GlobalErrorHandlerProtocol = GlobalErrorHandler.shared, tokenProvider: @escaping () -> String? = { nil }
) {
        self.baseURL = baseURL
        self.session = session
        self.errorHandler = errorHandler
        self.tokenProvider = tokenProvider
    }

    func get<T: Decodable>(_ endpoint: ApiEndpoint) async throws -> T {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        addAuthHeaderIfNeeded(to: &request, endpoint: endpoint)
        
        print("🌐 GET Request: \(request.url?.absoluteString ?? "unknown URL")")
        print("📤 Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Log response details
            if let httpResponse = response as? HTTPURLResponse {
                print("📥 GET Response received: \(data.count) bytes, status: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 GET Response body: \(responseString)")
                }
            }
            
            let result: T = try decodeResponse(data: data, response: response)
            return result
        } catch {
            print("❌ GET Request failed: \(error)")
            throw error
        }
    }

    func post<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeaderIfNeeded(to: &request, endpoint: endpoint)
        
        print("🌐 POST Request: \(request.url?.absoluteString ?? "unknown URL")")
        print("📤 Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📤 Body: \(bodyString)")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Log response details
            if let httpResponse = response as? HTTPURLResponse {
                print("📥 Response received: \(data.count) bytes, status: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response body: \(responseString)")
                }
            }
            
            let result: T = try decodeResponse(data: data, response: response)
            return result
        } catch {
            throw error
        }
    }
    
    func postVoid<U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws {
        print("🌐 HttpClient.postVoid: Starting request to endpoint: \(endpoint)")
        var request = try endpoint.makeRequest(baseURL: baseURL)
        print("🌐 HttpClient.postVoid: Request URL: \(request.url?.absoluteString ?? "nil")")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeaderIfNeeded(to: &request, endpoint: endpoint)
        print("🌐 HttpClient.postVoid: Set headers and body")
        
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📤 Body: \(bodyString)")
        }
        
        print("🌐 HttpClient.postVoid: Making URLSession.data request")
        do {
            let (data, response) = try await session.data(for: request)
            print("🌐 HttpClient.postVoid: Received response")
            try validateResponse(response: response, data: data)
            print("✅ HttpClient.postVoid: Request completed successfully")
        } catch {
            print("❌ HttpClient.postVoid: Request failed with error: \(error)")
            throw error
        }
    }
    
    func put<T: Decodable, U: Encodable>(_ endpoint: ApiEndpoint, body: U) async throws -> T {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        addAuthHeaderIfNeeded(to: &request, endpoint: endpoint)
        
        do {
            let (data, response) = try await session.data(for: request)
            let result: T = try decodeResponse(data: data, response: response)
            return result
        } catch {
            throw error
        }
    }
    
    func delete(_ endpoint: ApiEndpoint) async throws {
        var request = try endpoint.makeRequest(baseURL: baseURL)
        request.httpMethod = "DELETE"
        addAuthHeaderIfNeeded(to: &request, endpoint: endpoint)
        
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response: response, data: data)
        } catch {
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
    
    private func addAuthHeaderIfNeeded(
        to request: inout URLRequest,
        endpoint: ApiEndpoint
    ) {
        if endpoint.requiresAuth {
            if let token = tokenProvider() {
                print("🔑 HttpClient: Adding auth token for \(endpoint) - Token: \(String(token.prefix(20)))...")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("⚠️ HttpClient: No token available for \(endpoint) (requires auth)")
            }
        } else {
            print("🔓 HttpClient: No auth required for \(endpoint)")
        }
    }
}
