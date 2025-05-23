import UIKit

final class LoginViewController: UIViewController {
    private var loginViewModel: LoginViewModelProtocol
    
    // MARK: - UI Components
    private let mainImageView: UIImageView = {
        let imageView = UIImageView(image: .mainLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginTextField: CustomTextField = {
        let textField = CustomTextField(icon: UIImage.userIcon, placeholder: "Username")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(icon: UIImage.lockIcon, placeholder: "Password")
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.poppinsSemiBold(size: 15)
        button.backgroundColor = UIColor.darkPurple
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .back
        setupKeyboardConfiguration()
        setupUI()
        bindViewModel()
    }

    init(loginViewModel: LoginViewModelProtocol = LoginViewModel()) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        view.addSubview(mainImageView)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.MainImage.sides),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.MainImage.sides),
            mainImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: LayoutConstants.MainImage.topAnchor
            ),
            mainImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.MainImage.height),
            
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Fields.sides),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.Fields.sides),
            loginTextField.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: LayoutConstants.Fields.topAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.Fields.height),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Fields.sides),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.Fields.sides),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: LayoutConstants.Fields.space),
            passwordTextField.heightAnchor.constraint(equalToConstant: LayoutConstants.Fields.height),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Fields.sides),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.Fields.sides),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: LayoutConstants.Fields.space),
            loginButton.heightAnchor.constraint(equalToConstant: LayoutConstants.Fields.height)
        ])
    }

    private func bindViewModel() {
        loginViewModel.onLoginSuccess = {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    return
                }
                let homeTabBarController = MainTabViewController()
                window.rootViewController = homeTabBarController
                window.makeKeyAndVisible()

                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                window.layer.add(transition, forKey: kCATransition)
            }
        }

        loginViewModel.onLoginFailed = { [weak self] message in
            self?.passwordTextField.text = ""
            self?.loginTextField.text = ""
        }

        loginViewModel.onShowAlert = { [weak self] alert in
            self?.present(alert, animated: true)
        }
    }

    @objc private func loginButtonTapped() {
        loginViewModel.username = loginTextField.text ?? ""
        loginViewModel.password = passwordTextField.text ?? ""
        loginViewModel.authenticate()
    }

    // MARK: - Keyboard setup
    private func setupKeyboardConfiguration() {
        setupKeyboardObservers()
        setupDismissKeyboardGesture()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let fixedOffset: CGFloat = 220
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = -fixedOffset
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
            self.view.frame.origin.y = 0
        }
    }

    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        dismissKeyboardTap.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTap)
    }

    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: view)

        if !loginButton.frame.contains(tapLocation) {
            view.endEditing(true)
        }
    }
}

private enum LayoutConstants {
    enum Fields {
        static let topAnchor: CGFloat = 174
        static let height: CGFloat = 55
        static let sides: CGFloat = 25
        static let space: CGFloat = 20
    }
    enum MainImage {
        static let topAnchor: CGFloat = 13
        static let height: CGFloat = 287
        static let sides: CGFloat = 44
    }
}
