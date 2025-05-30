import UIKit

final class LogoutButtonOptionsView: UIButton {
    init(title: String, image: UIImage?, action: Selector, target: Any?) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.baseForegroundColor = .darkPurple
        config.imagePadding = 8
        config.titleAlignment = .leading
        config.contentInsets = .zero
        
        configuration = config
        titleLabel?.font = .poppinsMedium(size: 18)
        backgroundColor = .white
        layer.cornerRadius = 8
        contentHorizontalAlignment = .leading
        
        if let target = target {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
