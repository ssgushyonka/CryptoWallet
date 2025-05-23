import UIKit

final class TrendingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TrendingTableViewCell"
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 18)
        label.textColor = .darkPurple
        return label
    }()
    
    private lazy var shortCoinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 14)
        label.textColor = .grayPurple
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 18)
        label.textColor = .darkPurple
        return label
    }()
    
    private lazy var changeIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var procentChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 14)
        label.textColor = .grayPurple
        return label
    }()
    
    private lazy var changeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [changeIconView, procentChangeLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .tableViewBack
        
        let subViews = [
            coinNameLabel,
            shortCoinNameLabel,
            priceLabel,
            changeStackView,
            coinImageView
        ]
        subViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: CoinCellViewModel) {
        coinNameLabel.text = viewModel.fullName
        shortCoinNameLabel.text = viewModel.shortName
        priceLabel.text = viewModel.price
        procentChangeLabel.text = viewModel.percentChange
        changeIconView.image = UIImage(named: viewModel.changeIconName)
        coinImageView.image = viewModel.coinImage
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            coinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingOffset),
            coinImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.topOffset),
            coinImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.coinImageSize),
            coinImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.coinImageSize),
            
            coinNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.coinNameLeadingOffset),
            coinNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.topOffset),
            
            shortCoinNameLabel.leadingAnchor.constraint(equalTo: coinNameLabel.leadingAnchor),
            shortCoinNameLabel.topAnchor.constraint(equalTo: coinNameLabel.bottomAnchor, constant: LayoutConstants.smallVerticalSpacing),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingOffset),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.topOffset),
            
            changeStackView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            changeStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: LayoutConstants.smallVerticalSpacing)
        ])
    }
}

private enum LayoutConstants {
    static let leadingOffset: CGFloat = 25
    static let trailingOffset: CGFloat = -25
    static let topOffset: CGFloat = 10
    static let smallVerticalSpacing: CGFloat = 4
    static let coinImageSize: CGFloat = 50
    static let coinNameLeadingOffset: CGFloat = 94
}
