import UIKit

final class CoinRatesViewController: UIViewController {
    private lazy var viewModel = CoinRatesViewModel()
    private lazy var trendingTableView = TrendingTableView()
    private let userDefaultsManager = UserDefaultsManager()

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
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.tintColor = .darkBlue
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleLogoutOptions), for: .touchUpInside)
        return button
    }()

    @objc private func toggleLogoutOptions() {
        if logoutOptionsView.superview == nil {
            view.addSubview(logoutOptionsView)
            
            NSLayoutConstraint.activate([
                logoutOptionsView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 8),
                logoutOptionsView.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
                logoutOptionsView.widthAnchor.constraint(equalToConstant: 160)
            ])
        } else {
            logoutOptionsView.removeFromSuperview()
        }
    }

    private lazy var logoutOptionsView: LogoutButtonView = {
        let view = LogoutButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onRefresh = { [weak self] in
            self?.viewModel.fetchCoins()
        }
        view.onExit = { [weak self] in
            self?.userDefaultsManager.removeObject(forKey: "isLogin")
            
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self?.present(loginVC, animated: true, completion: nil)
        }
        return view
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
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(.sortIcon, for: .normal)
        button.addTarget(self, action: #selector(showSortOptions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightPink
        setupBindings()
        setupConstraints()

        trendingTableView.delegate = self
        trendingTableView.dataSource = self
        viewModel.fetchCoins()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupConstraints() {
        view.addSubview(homeLabel)
        view.addSubview(subLabel)
        view.addSubview(homeImage)
        view.addSubview(learnMoreButton)
        view.addSubview(logoutButton)
        view.addSubview(tableViewHeader)
        view.addSubview(trendingLabel)
        view.addSubview(sortButton)
        view.addSubview(trendingTableView)

        NSLayoutConstraint.activate([
            homeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            homeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            homeLabel.heightAnchor.constraint(equalToConstant: 48),
            homeLabel.widthAnchor.constraint(equalToConstant: 97),
            
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
            
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            sortButton.topAnchor.constraint(equalTo: tableViewHeader.topAnchor, constant: 24),
            sortButton.heightAnchor.constraint(equalToConstant: 24),
            sortButton.widthAnchor.constraint(equalToConstant: 24),
            
            trendingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trendingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trendingTableView.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: 16),
            trendingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }

    private func handleRefresh() {
        logoutOptionsView.removeFromSuperview()
        viewModel.fetchCoins()
    }

    private func handleExit() {
        logoutOptionsView.removeFromSuperview()
        navigationController?.popToRootViewController(animated: true)
    }

    private func setupBindings() {
        viewModel.onCoinsUpdated = { [weak self] isLoading in
            guard let self = self else { return }
            self.trendingTableView.update(with: self.viewModel.cellModels, isLoading: isLoading)
        }
    }

    private func showCoinDetailScreen(for coinModel: CoinCellModel) {
        let detailViewModel = CoinCellViewModel(model: coinModel)
        let detailVC = CoinDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc private func showSortOptions() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По возрастанию", style: .default) { [weak self] _ in
            self?.viewModel.sortCoins(by: .more)
        })

        alert.addAction(UIAlertAction(title: "По убыванию", style: .default) { [weak self] _ in
            self?.viewModel.sortCoins(by: .less)
        })

        alert.addAction(UIAlertAction(title: "Сбросить сортировку", style: .destructive) { [weak self] _ in
            self?.viewModel.sortCoins(by: .none)
        })

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension CoinRatesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trendingTableView = tableView as? TrendingTableView else { return 0 }
        return trendingTableView.getCellModelsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let trendingTableView = tableView as? TrendingTableView,
              let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.reuseIdentifier, for: indexPath) as? TrendingTableViewCell else {
            return UITableViewCell()
        }

        let model = trendingTableView.getCellModel(at: indexPath)
        let viewModel = CoinCellViewModel(model: model)
        cell.configure(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let trendingTableView = tableView as? TrendingTableView else { return }
        let selectedCoin = trendingTableView.getCellModel(at: indexPath)
        showCoinDetailScreen(for: selectedCoin)
    }
}
