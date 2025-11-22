import Foundation

struct JWTDecoder {
    static func decodeEmail(from token: String) -> String? {
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
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let email = json["email"] as? String {
                return email
            }
        } catch {
            print("❌ JWT Decode Error: \(error)")
        }
        
        return nil
    }
}