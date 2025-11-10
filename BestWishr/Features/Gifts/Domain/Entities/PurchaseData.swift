import Foundation

struct PricePoint: Codable {
    let price: Double
    let currency: String
    let date: Date
    let retailer: String?
}

struct PurchaseData: Codable {
    let retailer: String?
    let purchaseMethod: PurchaseMethod
    let shippingAddress: Address?
    let giftMessage: String?
    let deliveryDate: Date?
}

enum PurchaseMethod: String, CaseIterable, Codable {
    case inApp = "In-App"
    case external = "External Link"
    case inStore = "In Store"
    case other = "Other"
}

struct Address: Codable {
    let street: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
}

struct PurchaseResult: Codable {
    let success: Bool
    let orderId: String?
    let trackingNumber: String?
    let estimatedDelivery: Date?
    let error: String?
    let externalURL: String?
}