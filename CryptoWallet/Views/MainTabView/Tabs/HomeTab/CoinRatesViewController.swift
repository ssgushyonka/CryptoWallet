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

        let menu = UIMenu(title: "Сортировка", children: [
            UIAction(title: "По возрастанию", handler: { [weak self] _ in
                self?.viewModel.sortCoins(by: .more)
            }),
            UIAction(title: "По убыванию", handler: { [weak self] _ in
                self?.viewModel.sortCoins(by: .less)
            }),
            UIAction(title: "Сбросить сортировку", attributes: .destructive, handler: { [weak self] _ in
                self?.viewModel.sortCoins(by: .none)
            })
        ])

        button.menu = menu
        button.showsMenuAsPrimaryAction = true
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
            homeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.Margins.top),
            homeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Margins.horizontal),
            homeLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.Sizes.homeLabel.height),
            homeLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.Sizes.homeLabel.width),
            
            subLabel.topAnchor.constraint(equalTo: homeLabel.bottomAnchor, constant: LayoutConstants.Spacing.xxLarge),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Margins.horizontal),
            subLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.Sizes.subLabelHeight),
            
            homeImage.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: LayoutConstants.Spacing.large),
            homeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Sizes.homeImageLeading),
            homeImage.heightAnchor.constraint(equalToConstant: LayoutConstants.Sizes.homeImage),
            homeImage.widthAnchor.constraint(equalToConstant: LayoutConstants.Sizes.homeImage),
            
            learnMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Margins.horizontal),
            learnMoreButton.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: LayoutConstants.Spacing.small),
            learnMoreButton.heightAnchor.constraint(equalToConstant: LayoutConstants.Sizes.learnMoreButton.height),
            learnMoreButton.widthAnchor.constraint(equalToConstant: LayoutConstants.Sizes.learnMoreButton.width),
            
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.Margins.top),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.Margins.horizontal),
            logoutButton.heightAnchor.constraint(equalToConstant: LayoutConstants.Sizes.logoutButton),
            logoutButton.widthAnchor.constraint(equalToConstant: LayoutConstants.Sizes.logoutButton),
            
            tableViewHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewHeader.topAnchor.constraint(equalTo: learnMoreButton.bottomAnchor, constant: LayoutConstants.Spacing.header),
            tableViewHeader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trendingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.Margins.horizontal),
            trendingLabel.topAnchor.constraint(equalTo: tableViewHeader.topAnchor, constant: LayoutConstants.Spacing.xLarge),
            
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.Margins.horizontal),
            sortButton.topAnchor.constraint(equalTo: tableViewHeader.topAnchor, constant: LayoutConstants.Spacing.xLarge),
            sortButton.heightAnchor.constraint(equalToConstant: LayoutConstants.Sizes.sortButton),
            sortButton.widthAnchor.constraint(equalToConstant: LayoutConstants.Sizes.sortButton),
            
            trendingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trendingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trendingTableView.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: LayoutConstants.Spacing.medium),
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

    @objc private func toggleLogoutOptions() {
        if logoutOptionsView.superview == nil {
            view.addSubview(logoutOptionsView)
            
            NSLayoutConstraint.activate([
                logoutOptionsView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 8),
                logoutOptionsView.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
                logoutOptionsView.widthAnchor.constraint(equalToConstant: 157),
                logoutOptionsView.heightAnchor.constraint(equalToConstant: 102)
            ])
        } else {
            logoutOptionsView.removeFromSuperview()
        }
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

private enum LayoutConstants {
    enum Margins {
        static let horizontal: CGFloat = 25
        static let top: CGFloat = 57
    }

    enum Spacing {
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 21
        static let xLarge: CGFloat = 24
        static let xxLarge: CGFloat = 46
        static let header: CGFloat = 55
    }

    enum Sizes {
        static let homeLabel = CGSize(width: 97, height: 48)
        static let subLabelHeight: CGFloat = 30
        static let learnMoreButton = CGSize(width: 127, height: 35)
        static let logoutButton: CGFloat = 48
        static let sortButton: CGFloat = 24
        static let homeImage: CGFloat = 242
        static let homeImageLeading: CGFloat = 189
    }
}
