import UIKit

final class MainTabBar: UITabBar {
    private var customHeight: CGFloat = 82

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subviews
            .filter { $0 is UIControl }
            .forEach { $0.frame.origin.y = 17 }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }

    private func setupAppearance() {
        tintColor = .darkBlue
        unselectedItemTintColor = .tabBarIcons
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.02
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 4
    }
}
