import UIKit

final class CustomSegmentedView: UIView {
    let segmentedControl: UISegmentedControl = {
        let items = ["24H", "1W", "1Y", "ALL", "Point"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentTintColor = .white.withAlphaComponent(0.8)
        control.backgroundColor = .segmentedBack

        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkBlue,
            .font: UIFont.poppinsSemiBold(size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.grayPurple,
            .font: UIFont.poppinsMedium(size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        ]

        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)

        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
        
        segmentedControl.layer.cornerRadius = 25
        segmentedControl.clipsToBounds = true
        segmentedControl.layer.masksToBounds = true
    }
}
