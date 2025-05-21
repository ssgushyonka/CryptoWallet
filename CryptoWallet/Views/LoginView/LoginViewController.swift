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
        view.backgroundColor = UIColor.back
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

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
    
    private func bindViewModel() {
        loginViewModel.onLoginSuccess = { [weak self] in
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
        }
        
        loginViewModel.onShowAlert = { [weak self] alert in
            self?.present(alert, animated: true)
        }
    }
    
    private func setupUI() {
        view.addSubview(mainImageView)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            mainImageView.heightAnchor.constraint(equalToConstant: 287),
            
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            loginTextField.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 174),
            loginTextField.heightAnchor.constraint(equalToConstant: 55),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - objc funcs
    @objc private func loginButtonTapped() {
        loginViewModel.username = loginTextField.text ?? ""
        loginViewModel.password = passwordTextField.text ?? ""
        loginViewModel.authenticate()
        print("login tapped")
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardTopY = view.frame.height - keyboardFrame.height

        let passwordFieldFrame = passwordTextField.convert(passwordTextField.bounds, to: view)
        let passwordFieldBottomY = passwordFieldFrame.maxY

        if passwordFieldBottomY > keyboardTopY {
            let overlap = passwordFieldBottomY - keyboardTopY + 80
            view.frame.origin.y = -overlap
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
