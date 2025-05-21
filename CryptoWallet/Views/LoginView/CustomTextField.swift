import UIKit

final class CustomTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 20)
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    init(icon: UIImage?, placeholder: String) {
        super.init(frame: .zero)
        setupView(icon: icon, placeholder: placeholder)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(icon: UIImage?, placeholder: String) {
        backgroundColor = .white
        layer.cornerRadius = 25
        layer.masksToBounds = true
        textColor = UIColor.black
        font = UIFont.poppinsRegular(size: 15)
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.grayPurple
            ]
        )
        iconImageView.image = icon
        leftView = iconImageView
        leftViewMode = .always
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    // MARK: - Overriden funcs
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 10
        return rect
    }
}
