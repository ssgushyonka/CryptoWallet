import UIKit

final class TrendingTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    private var cellModels: [CoinCellModel] = []
    var onDidSelectCoin: ((CoinCellModel) -> Void)?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init() {
        super.init(frame: .zero, style: .plain)
        setupViews()
    }

    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = .tableViewBack
        register(TrendingTableViewCell.self, forCellReuseIdentifier: TrendingTableViewCell.reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        rowHeight = 70
        
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ])
    }
    
    func update(with models: [CoinCellModel], isLoading: Bool = false) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
            self.cellModels = models
            reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: TrendingTableViewCell.reuseIdentifier, for: indexPath) as? TrendingTableViewCell else {
            return UITableViewCell()
        }
        let model = cellModels[indexPath.row]
        cell.configure(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        let selectedCoin = cellModels[indexPath.row]
        onDidSelectCoin?(selectedCoin)
    }
}
