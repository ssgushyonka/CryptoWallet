import UIKit

final class CustomSegmentedView: UIView {
    var segments: [String] {
        didSet {
            configureButtons()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            updateSelection(animated: true)
            onSegmentChange?(selectedIndex)
        }
    }

    var onSegmentChange: ((Int) -> Void)?
    private var buttons: [UIButton] = []

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()

    init(segments: [String]) {
        self.segments = segments
        super.init(frame: CGRect(x: 0, y: 0, width: 325, height: 56))
        setupView()
        configureButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectorFrame(animated: false)
    }

    private func setupView() {
        backgroundColor = .segmentedBack
        layer.cornerRadius = 28
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectorView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 325, height: 56)
    }

    private func configureButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        segments.enumerated().forEach { index, title in
            let button = makeButton(with: title, tag: index)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }

        layoutIfNeeded()
        updateSelectorFrame(animated: false)
        updateSelection(animated: false)
    }

    private func makeButton(with title: String, tag: Int) -> UIButton {
        let button: UIButton

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = title
            config.baseForegroundColor = .grayPurple
            button = UIButton(configuration: config, primaryAction: nil)
        } else {
            button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.grayPurple, for: .normal)
            button.setTitleColor(.darkBlue, for: .selected)
        }
        button.titleLabel?.font = UIFont.poppinsMedium(size: 14)
        button.tintColor = .clear
        button.tag = tag
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        return button
    }

    private func updateSelection(animated: Bool) {
        buttons.enumerated().forEach { index, button in
            let isSelected = index == selectedIndex
            button.isSelected = isSelected
            if #available(iOS 15.0, *) {
                var config = button.configuration ?? UIButton.Configuration.plain()
                config.baseForegroundColor = isSelected ? .darkBlue : .grayPurple

                let font = isSelected ? UIFont.poppinsSemiBold(size: 14) : UIFont.poppinsRegular(size: 14)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font ?? UIFont.systemFont(ofSize: 14),
                    .foregroundColor: isSelected ? UIColor.darkBlue : UIColor.grayPurple
                ]
                config.attributedTitle = AttributedString(NSAttributedString(string: segments[index], attributes: attributes))

                if isSelected {
                    if index == 0 {
                        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 0)
                    } else if index == segments.count - 1 {
                        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
                    } else {
                        config.contentInsets = .zero
                    }
                } else {
                    config.contentInsets = .zero
                }
                button.configuration = config
            } else {
                button.setTitleColor(isSelected ? .darkBlue : .grayPurple, for: .normal)
                button.titleLabel?.font = isSelected ? UIFont.poppinsSemiBold(size: 14) : UIFont.poppinsRegular(size: 14)
                button.titleLabel?.textAlignment = isSelected
                    ? (index == 0 ? .left : (index == segments.count - 1 ? .right : .center))
                    : .center

                if isSelected {
                    if index == 0 {
                        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                    } else if index == segments.count - 1 {
                        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
                    } else {
                        button.titleEdgeInsets = .zero
                    }
                } else {
                    button.titleEdgeInsets = .zero
                }
            }
        }
        updateSelectorFrame(animated: animated)
    }

    private func updateSelectorFrame(animated: Bool) {
        guard selectedIndex < buttons.count else { return }

        let buttonFrame = buttons[selectedIndex].frame
        let selectorWidth: CGFloat = 70
        let selectorHeight: CGFloat = 48
        let xPosition = buttonFrame.midX - selectorWidth/2
        let yPosition: CGFloat = 4
        let clampedX = xPosition < 4 ? 4 : (xPosition > bounds.width - selectorWidth - 4 ? bounds.width - selectorWidth - 4 : xPosition)
        let selectedFrame = CGRect(x: clampedX, y: yPosition, width: selectorWidth, height: selectorHeight)
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                self.selectorView.frame = selectedFrame
            }
        } else {
            selectorView.frame = selectedFrame
        }
    }

    @objc private func didTapButton(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
}
