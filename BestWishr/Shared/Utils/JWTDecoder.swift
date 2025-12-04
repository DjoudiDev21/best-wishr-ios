import Foundation

struct JWTDecoder {
    static func decodeEmail(from token: String) -> String? {
        guard let payload = decodePayload(from: token) else { return nil }
        return payload["email"] as? String
    }
    
    static func isTokenExpired(_ token: String) -> Bool {
        guard let payload = decodePayload(from: token) else { return true }
        guard let exp = payload["exp"] as? TimeInterval else { return true }
        
        let currentTime = Date().timeIntervalSince1970
        return currentTime >= exp
    }
    
    static func isTokenValid(_ token: String) -> Bool {
        return !isTokenExpired(token)
    }
    
    private static func decodePayload(from token: String) -> [String: Any]? {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { return nil }
        
        let payloadPart = parts[1]
        
        // Add padding if needed
        var paddedPayload = payloadPart
        let remainder = paddedPayload.count % 4
        if remainder > 0 {
            paddedPayload += String(repeating: "=", count: 4 - remainder)
        }
        
        guard let data = Data(base64Encoded: paddedPayload) else { return nil }
        
        do {
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            return nil
        }
    }
}
