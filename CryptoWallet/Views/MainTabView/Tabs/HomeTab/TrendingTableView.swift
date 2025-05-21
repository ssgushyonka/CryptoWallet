import UIKit

final class TrendingTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    private var cellModels: [CoinCellModel] = []

    init() {
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = .tableViewBack
        register(TrendingTableViewCell.self, forCellReuseIdentifier: TrendingTableViewCell.reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        rowHeight = 80
    }

    required init?(coder: NSCoder) { fatalError() }

    func update(with models: [CoinCellModel]) {
        self.cellModels = models
        reloadData()
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
    }
}
