import Foundation

struct PhoneNumberValidator {
    
    /// Validates and formats phone number with country code for backend API compatibility
    /// Backend uses libphonenumber-js and expects international format: +[country_code][number]
    static func validateAndFormat(_ phone: String?, country: Country) -> String? {
        guard let phone = phone, !phone.isEmpty else { return nil }
        
        // Clean the phone number (remove spaces, parentheses, dashes, dots)
        let cleanedPhone = phone.replacingOccurrences(of: "[\\s\\(\\)\\-\\.]", with: "", options: .regularExpression)
        
        // If already in international format, validate and return
        if cleanedPhone.hasPrefix("+") {
            if isValidInternationalFormat(cleanedPhone) {
                return cleanedPhone
            } else {
                return nil
            }
        }
        
        // Convert national number to international using selected country
        if let internationalNumber = convertToInternational(cleanedPhone, country: country) {
            return internationalNumber
        } else {
            return nil
        }
    }
    
    private static func isValidInternationalFormat(_ phone: String) -> Bool {
        // Must start with + followed by 1-3 digits (country code) then 4-14 more digits
        let internationalRegex = "^\\+[1-9]\\d{0,3}\\d{4,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", internationalRegex)
        return predicate.evaluate(with: phone) && phone.count >= 8 && phone.count <= 16
    }
    
    private static func convertToInternational(_ nationalNumber: String, country: Country) -> String? {
        // Remove leading zeros (common in national formats)
        let cleanNumber = nationalNumber.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        
        // Must contain only digits
        guard cleanNumber.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        
        // Basic length validation (4-14 digits for national part)
        guard cleanNumber.count >= 4 && cleanNumber.count <= 14 else {
            return nil
        }
        
        // Combine country code with national number
        let internationalNumber = "\(country.phoneCode)\(cleanNumber)"
        
        // Validate the result
        if isValidInternationalFormat(internationalNumber) {
            return internationalNumber
        }
        
        return nil
    }
    
    static func detectCountryFromPhoneNumber(_ phoneNumber: String?) -> Country {
        guard let phoneNumber = phoneNumber, phoneNumber.hasPrefix("+") else {
            return Country.default
        }
        
        // Extract potential country codes (1-4 digits after +)
        let cleanNumber = phoneNumber.dropFirst() // Remove +
        
        // Try longest country codes first (4 digits, then 3, then 2, then 1)
        for length in (1...4).reversed() {
            if cleanNumber.count >= length {
                let potentialCode = "+\(cleanNumber.prefix(length))"
                if let country = Country.findByPhoneCode(potentialCode) {
                    return country
                }
            }
        }
        
        return Country.default
    }
}
