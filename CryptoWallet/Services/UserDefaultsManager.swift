import Foundation

protocol UserDefaultsManagerProtocol {
    func set(_ value: Any?, forKey key: String)
    func getBool(forKey key: String) -> Bool
    func removeObject(forKey key: String)
}

final class UserDefaultsManager: UserDefaultsManagerProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func getBool(forKey key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
