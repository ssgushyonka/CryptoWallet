import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    private let mainImageView: UIImageView = {
        let imageView = UIImageView(image: .mainLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginTextField: CustomTextField = {
        let tf = CustomTextField(icon: UIImage.userIcon, placeholder: "Username")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(icon: UIImage.lockIcon, placeholder: "Password")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.back
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(mainImageView)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)

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
            passwordTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
