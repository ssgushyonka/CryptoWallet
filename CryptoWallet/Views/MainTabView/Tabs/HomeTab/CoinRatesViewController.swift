import UIKit

final class CoinRatesViewController: UIViewController {
    private lazy var viewModel = CoinRatesViewModel()
    private lazy var trendingTableView = TrendingTableView()

    private lazy var homeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = .poppinsSemiBold(size: 32)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.text = "Affiliate program"
        label.font = .poppinsMedium(size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var homeImage: UIImageView = {
        let imageView = UIImageView(image: .home)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn more", for: .normal)
        button.titleLabel?.font = .poppinsSemiBold(size: 14)
        button.backgroundColor = .white
        button.setTitleColor(.darkBlue, for: .normal)
        button.layer.cornerRadius = 17.5
        //button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.tintColor = .darkBlue
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableViewHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewBack
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trendingLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsMedium(size: 20)
        label.textColor = .darkPurple
        label.text = "Trending"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightPink
        setupBindings()
        setupConstraints()
        viewModel.fetchCoins()
    }
    
    private func setupBindings() {
        viewModel.onCoinsUpdated = { [weak self] in
            guard let self = self else { return }
            self.trendingTableView.update(with: self.viewModel.cellModels)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(homeLabel)
        view.addSubview(subLabel)
        view.addSubview(homeImage)
        view.addSubview(learnMoreButton)
        view.addSubview(logoutButton)
        view.addSubview(tableViewHeader)
        view.addSubview(trendingLabel)
        view.addSubview(trendingTableView)
        
        NSLayoutConstraint.activate([
            homeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            homeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            homeLabel.heightAnchor.constraint(equalToConstant: 48),
            
            subLabel.topAnchor.constraint(equalTo: homeLabel.bottomAnchor, constant: 46),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            subLabel.heightAnchor.constraint(equalToConstant: 30),
            
            homeImage.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 21),
            homeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 189),
            homeImage.heightAnchor.constraint(equalToConstant: 242),
            homeImage.widthAnchor.constraint(equalToConstant: 242),
            
            learnMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            learnMoreButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 12),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 35),
            learnMoreButton.widthAnchor.constraint(equalToConstant: 127),
            
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            logoutButton.heightAnchor.constraint(equalToConstant: 48),
            logoutButton.widthAnchor.constraint(equalToConstant: 48),
            
            tableViewHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewHeader.topAnchor.constraint(equalTo: learnMoreButton.bottomAnchor, constant: 55),
            tableViewHeader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trendingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            trendingLabel.topAnchor.constraint(equalTo: tableViewHeader.topAnchor, constant: 24),
            
            trendingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trendingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trendingTableView.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: 16),
            trendingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
