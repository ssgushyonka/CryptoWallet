import UIKit

final class TrendingTableView: UITableView {
    private var cellModels: [CoinCellModel] = []
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
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
    
    func getCellModel(at indexPath: IndexPath) -> CoinCellModel {
        return cellModels[indexPath.row]
    }
    
    func getCellModelsCount() -> Int {
        return cellModels.count
    }
}
