import UIKit

final class CoinDetailViewController: UIViewController {
    private let viewModel: CoinCellViewModel
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.leftArrow, for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 14)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 28)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 14)
        label.textColor = .grayPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var changeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [changeImageView, percentLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var dateSegmentedView: CustomSegmentedView = {
        let view = CustomSegmentedView(segments: ["24H", "1W", "1Y", "ALL", "Point"])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundCard1
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var marketStatisticLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Statistic"
        label.font = .poppinsMedium(size: 20)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var marketCapitalizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Market capitalization"
        label.font = .poppinsMedium(size: 14)
        label.textColor = .grayPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var circulatingSuplyLabel: UILabel = {
        let label = UILabel()
        label.text = "Circulating Suply"
        label.font = .poppinsMedium(size: 14)
        label.textColor = .grayPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var capitalizationPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsSemiBold(size: 14)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var suplyValueLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsSemiBold(size: 14)
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: CoinCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = .detailViewBack
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.poppinsMedium(size: 14)!,
            .foregroundColor: UIColor.darkPurple
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.hidesBackButton = true
    }
    
    private func setupConstraints() {
        view.addSubview(backButton)
        view.addSubview(coinNameLabel)
        view.addSubview(priceLabel)
        view.addSubview(changeStackView)
        view.addSubview(dateSegmentedView)
        view.addSubview(backgroundCardView)
        view.addSubview(marketStatisticLabel)
        view.addSubview(marketCapitalizationLabel)
        view.addSubview(circulatingSuplyLabel)
        view.addSubview(capitalizationPriceLabel)
        view.addSubview(suplyValueLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.backButtonLeading),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.backButtonTop),
            backButton.heightAnchor.constraint(equalToConstant: LayoutConstants.backButtonSize),
            backButton.widthAnchor.constraint(equalToConstant: LayoutConstants.backButtonSize),
            
            coinNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coinNameLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.topAnchor.constraint(equalTo: coinNameLabel.bottomAnchor, constant: LayoutConstants.mediumSpacing),
            
            changeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: LayoutConstants.noSpacing),
            
            dateSegmentedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateSegmentedView.topAnchor.constraint(equalTo: changeStackView.bottomAnchor, constant: LayoutConstants.mediumSpacing),
            
            backgroundCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -LayoutConstants.cardTopOffset),
            backgroundCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            marketStatisticLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: LayoutConstants.cardContentLeading),
            marketStatisticLabel.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: LayoutConstants.cardTopInset),
            
            marketCapitalizationLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: LayoutConstants.cardContentLeading),
            marketCapitalizationLabel.topAnchor.constraint(equalTo: marketStatisticLabel.bottomAnchor, constant: LayoutConstants.smallSpacing),
            
            circulatingSuplyLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: LayoutConstants.cardContentLeading),
            circulatingSuplyLabel.topAnchor.constraint(equalTo: marketCapitalizationLabel.bottomAnchor, constant: LayoutConstants.smallSpacing),
            
            capitalizationPriceLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -LayoutConstants.cardContentLeading),
            capitalizationPriceLabel.topAnchor.constraint(equalTo: marketStatisticLabel.bottomAnchor, constant: LayoutConstants.smallSpacing),

            suplyValueLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -LayoutConstants.cardContentLeading),
            suplyValueLabel.topAnchor.constraint(equalTo: marketCapitalizationLabel.bottomAnchor, constant: LayoutConstants.smallSpacing)
        ])
    }
    
    private func setupBindings() {
        coinNameLabel.text = "\(viewModel.fullName) (\(viewModel.shortName))"
        priceLabel.text = viewModel.price
        percentLabel.text = viewModel.percentChange
        changeImageView.image = UIImage(named: viewModel.changeIconName)
        capitalizationPriceLabel.text = viewModel.marketCap
        suplyValueLabel.text = viewModel.circulatingSupplyInCoins
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

private enum LayoutConstants {
    static let backButtonLeading: CGFloat = 25
    static let backButtonTop: CGFloat = 57
    static let backButtonSize: CGFloat = 48
    
    static let mediumSpacing: CGFloat = 20
    static let smallSpacing: CGFloat = 15
    static let noSpacing: CGFloat = 0
    
    static let cardTopOffset: CGFloat = 160
    static let cardContentLeading: CGFloat = 25
    static let cardTopInset: CGFloat = 25
}
