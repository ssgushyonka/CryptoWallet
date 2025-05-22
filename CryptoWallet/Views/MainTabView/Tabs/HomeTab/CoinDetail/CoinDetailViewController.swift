import UIKit

final class CoinDetailViewController: UIViewController {
    private let viewModel: CoinDetailViewModel

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
        let view = CustomSegmentedView()
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
    
    init(viewModel: CoinDetailViewModel) {
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

    private func setupUI() {
        view.backgroundColor = .detailViewBack
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.poppinsMedium(size: 14)!,
            .foregroundColor: UIColor.darkPurple
        ]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func setupBindings() {
        title = viewModel.coinName
        priceLabel.text = viewModel.coinModel.price
        percentLabel.text = viewModel.coinModel.percentChange
        changeImageView.image = UIImage(named: viewModel.coinModel.changeIconName)
        capitalizationPriceLabel.text = viewModel.coinModel.marketCap
        suplyValueLabel.text = viewModel.coinModel.circulatingSupply
    }
    
    private func setupConstraints() {
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
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            
            changeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            
            dateSegmentedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateSegmentedView.topAnchor.constraint(equalTo: changeStackView.bottomAnchor, constant: 20),
            dateSegmentedView.widthAnchor.constraint(equalToConstant: 325),
            dateSegmentedView.heightAnchor.constraint(equalToConstant: 56),
            
            backgroundCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 570),
            backgroundCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            marketStatisticLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 25),
            marketStatisticLabel.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 25),
            
            marketCapitalizationLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 25),
            marketCapitalizationLabel.topAnchor.constraint(equalTo: marketStatisticLabel.bottomAnchor, constant: 15),
            
            circulatingSuplyLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 25),
            circulatingSuplyLabel.topAnchor.constraint(equalTo: marketCapitalizationLabel.bottomAnchor, constant: 18),
            
            capitalizationPriceLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -25),
            capitalizationPriceLabel.topAnchor.constraint(equalTo: marketStatisticLabel.bottomAnchor, constant: 15),
            
            suplyValueLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -25),
            suplyValueLabel.topAnchor.constraint(equalTo: marketCapitalizationLabel.bottomAnchor, constant: 18)
        ])
    }
}
