import Foundation

struct MobileLogoutDto: Encodable {
    let refreshToken: String
    let deviceId: String?
    let pushToken: String?
    let logoutAllDevices: Bool?
    
    init(refreshToken: String, deviceId: String? = nil, pushToken: String? = nil, logoutAllDevices: Bool? = nil) {
        self.refreshToken = refreshToken
        self.deviceId = deviceId
        self.pushToken = pushToken
        self.logoutAllDevices = logoutAllDevices
    }
}