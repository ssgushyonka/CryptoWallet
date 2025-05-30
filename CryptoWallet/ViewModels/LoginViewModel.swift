import UIKit

protocol LoginViewModelProtocol {
    var username: String { get set }
    var password: String { get set }
    var onLoginSuccess: (() -> Void)? { get set }
    var onLoginFailed: ((String) -> Void)? { get set }
    var onShowAlert: ((UIAlertController) -> Void)? { get set }
    var isLoading: Bool { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    func authenticate()
    func handleFailedLogin(message: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    private let authService: AuthServiceProtocol
    var username: String = ""
    var password: String = ""

    var onLoginSuccess: (() -> Void)?
    var onLoginFailed: ((String) -> Void)?
    var onShowAlert: ((UIAlertController) -> Void)?
    var isLoading: Bool = false {
            didSet {
                onLoadingStateChanged?(isLoading)
            }
        }
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    func authenticate() {
        guard correctInputs() else {
            onLoginFailed?("Enter all the fields")
            return
        }
        isLoading = true
        authService.login(username: username, password: password) { [weak self] success in
            self?.isLoading = false
            if success {
                self?.onLoginSuccess?()
            } else {
                self?.handleFailedLogin(message: "Incorrect username or password")
            }
        }
    }

    func handleFailedLogin(message: String) {
        let alert = UIAlertController(
            title: "Login error",
            message: message,
            preferredStyle: .alert
        )

        let retryAction = UIAlertAction(title: "Retry", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.username = ""
            self?.password = ""
            self?.onLoginFailed?("Fields are empty")
        }

        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        onShowAlert?(alert)
    }

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    private func correctInputs() -> Bool {
        return !username.isEmpty && !password.isEmpty
    }
}
