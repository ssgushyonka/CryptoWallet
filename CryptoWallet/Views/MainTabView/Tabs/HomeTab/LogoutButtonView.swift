import UIKit

final class LogoutButtonView: UIView {
    var onRefresh: (() -> Void)?
    var onExit: (() -> Void)?
    
    private lazy var actionButtons: [UIButton] = [
        makeButton(title: "Обновить", image: .refreshIcon, action: #selector(didTapRefresh)),
        makeButton(title: "Выйти", image: .trashIcon, action: #selector(didTapExit))
    ]
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: actionButtons)
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) { nil }
    
    @objc private func didTapRefresh() { onRefresh?() }
    @objc private func didTapExit() { onExit?() }
    
    private func makeButton(title: String, image: UIImage?, action: Selector) -> UIButton {
        LogoutButtonOptionsView(
            title: title,
            image: image,
            action: action,
            target: self
        )
    }
    
    private func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
