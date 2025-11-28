import Foundation

struct Country: Identifiable, Codable {
    let id: String
    let name: String
    let code: String // ISO country code (US, FR, etc.)
    let phoneCode: String // Phone country code (+1, +33, etc.)
    let flag: String // Emoji flag
    
    var displayName: String {
        "\(flag) \(name) (\(phoneCode))"
    }
    
    var phoneDisplayName: String {
        "\(flag) \(phoneCode)"
    }
}

extension Country {
    static let allCountries: [Country] = [
        Country(id: "US", name: "United States", code: "US", phoneCode: "+1", flag: "🇺🇸"),
        Country(id: "CA", name: "Canada", code: "CA", phoneCode: "+1", flag: "🇨🇦"),
        Country(id: "GB", name: "United Kingdom", code: "GB", phoneCode: "+44", flag: "🇬🇧"),
        Country(id: "FR", name: "France", code: "FR", phoneCode: "+33", flag: "🇫🇷"),
        Country(id: "DE", name: "Germany", code: "DE", phoneCode: "+49", flag: "🇩🇪"),
        Country(id: "IT", name: "Italy", code: "IT", phoneCode: "+39", flag: "🇮🇹"),
        Country(id: "ES", name: "Spain", code: "ES", phoneCode: "+34", flag: "🇪🇸"),
        Country(id: "AU", name: "Australia", code: "AU", phoneCode: "+61", flag: "🇦🇺"),
        Country(id: "JP", name: "Japan", code: "JP", phoneCode: "+81", flag: "🇯🇵"),
        Country(id: "CN", name: "China", code: "CN", phoneCode: "+86", flag: "🇨🇳"),
        Country(id: "IN", name: "India", code: "IN", phoneCode: "+91", flag: "🇮🇳"),
        Country(id: "BR", name: "Brazil", code: "BR", phoneCode: "+55", flag: "🇧🇷"),
        Country(id: "MX", name: "Mexico", code: "MX", phoneCode: "+52", flag: "🇲🇽"),
        Country(id: "RU", name: "Russia", code: "RU", phoneCode: "+7", flag: "🇷🇺"),
        Country(id: "KR", name: "South Korea", code: "KR", phoneCode: "+82", flag: "🇰🇷"),
        Country(id: "NL", name: "Netherlands", code: "NL", phoneCode: "+31", flag: "🇳🇱"),
        Country(id: "CH", name: "Switzerland", code: "CH", phoneCode: "+41", flag: "🇨🇭"),
        Country(id: "SE", name: "Sweden", code: "SE", phoneCode: "+46", flag: "🇸🇪"),
        Country(id: "NO", name: "Norway", code: "NO", phoneCode: "+47", flag: "🇳🇴"),
        Country(id: "DK", name: "Denmark", code: "DK", phoneCode: "+45", flag: "🇩🇰"),
        Country(id: "FI", name: "Finland", code: "FI", phoneCode: "+358", flag: "🇫🇮"),
        Country(id: "PL", name: "Poland", code: "PL", phoneCode: "+48", flag: "🇵🇱"),
        Country(id: "BE", name: "Belgium", code: "BE", phoneCode: "+32", flag: "🇧🇪"),
        Country(id: "AT", name: "Austria", code: "AT", phoneCode: "+43", flag: "🇦🇹"),
        Country(id: "PT", name: "Portugal", code: "PT", phoneCode: "+351", flag: "🇵🇹"),
        Country(id: "GR", name: "Greece", code: "GR", phoneCode: "+30", flag: "🇬🇷"),
        Country(id: "TR", name: "Turkey", code: "TR", phoneCode: "+90", flag: "🇹🇷"),
        Country(id: "IL", name: "Israel", code: "IL", phoneCode: "+972", flag: "🇮🇱"),
        Country(id: "AE", name: "United Arab Emirates", code: "AE", phoneCode: "+971", flag: "🇦🇪"),
        Country(id: "SA", name: "Saudi Arabia", code: "SA", phoneCode: "+966", flag: "🇸🇦"),
        Country(id: "ZA", name: "South Africa", code: "ZA", phoneCode: "+27", flag: "🇿🇦"),
        Country(id: "EG", name: "Egypt", code: "EG", phoneCode: "+20", flag: "🇪🇬"),
        Country(id: "NG", name: "Nigeria", code: "NG", phoneCode: "+234", flag: "🇳🇬"),
        Country(id: "KE", name: "Kenya", code: "KE", phoneCode: "+254", flag: "🇰🇪"),
        Country(id: "MA", name: "Morocco", code: "MA", phoneCode: "+212", flag: "🇲🇦"),
        Country(id: "TN", name: "Tunisia", code: "TN", phoneCode: "+216", flag: "🇹🇳"),
        Country(id: "DZ", name: "Algeria", code: "DZ", phoneCode: "+213", flag: "🇩🇿"),
        Country(id: "SG", name: "Singapore", code: "SG", phoneCode: "+65", flag: "🇸🇬"),
        Country(id: "MY", name: "Malaysia", code: "MY", phoneCode: "+60", flag: "🇲🇾"),
        Country(id: "TH", name: "Thailand", code: "TH", phoneCode: "+66", flag: "🇹🇭"),
        Country(id: "VN", name: "Vietnam", code: "VN", phoneCode: "+84", flag: "🇻🇳"),
        Country(id: "ID", name: "Indonesia", code: "ID", phoneCode: "+62", flag: "🇮🇩"),
        Country(id: "PH", name: "Philippines", code: "PH", phoneCode: "+63", flag: "🇵🇭"),
        Country(id: "NZ", name: "New Zealand", code: "NZ", phoneCode: "+64", flag: "🇳🇿"),
        Country(id: "AR", name: "Argentina", code: "AR", phoneCode: "+54", flag: "🇦🇷"),
        Country(id: "CL", name: "Chile", code: "CL", phoneCode: "+56", flag: "🇨🇱"),
        Country(id: "CO", name: "Colombia", code: "CO", phoneCode: "+57", flag: "🇨🇴"),
        Country(id: "PE", name: "Peru", code: "PE", phoneCode: "+51", flag: "🇵🇪"),
        Country(id: "VE", name: "Venezuela", code: "VE", phoneCode: "+58", flag: "🇻🇪"),
        Country(id: "UY", name: "Uruguay", code: "UY", phoneCode: "+598", flag: "🇺🇾"),
    ]
    
    static let `default` = Country(id: "US", name: "United States", code: "US", phoneCode: "+1", flag: "🇺🇸")
    
    static func findByCode(_ code: String) -> Country? {
        return allCountries.first { $0.code.lowercased() == code.lowercased() }
    }
    
    static func findByPhoneCode(_ phoneCode: String) -> Country? {
        return allCountries.first { $0.phoneCode == phoneCode }
    }
}