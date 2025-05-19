import UIKit

protocol AuthServiceProtocol {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    func isLogin() -> Bool
    func logout()
}


final class AuthService: AuthServiceProtocol {
    private let userDefaultsManager: UserDefaultsManagerProtocol

    private let loginKey = "isLogin"
    private let correcUserName = "1234"
    private let correctPassword = "1234"

    init(userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            
            let success = ( username == self.correcUserName && password == self.correctPassword )
            if success {
                self.userDefaultsManager.set(true, forKey: self.loginKey)
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func isLogin() -> Bool {
        return userDefaultsManager.getBool(forKey: loginKey)
    }
    
    func logout() {
        userDefaultsManager.removeObject(forKey: loginKey)
    }
    
    
}
