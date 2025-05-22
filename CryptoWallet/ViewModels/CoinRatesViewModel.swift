import Foundation

enum SortDirection {
    case none
    case more
    case less
}

final class CoinRatesViewModel {
    private var currentSortDirection: SortDirection = .none
    private let coinService = CoinMetricsService()
    private var originalCoins: [CoinMetricsData] = []
    var cellModels: [CoinCellModel] = []

    private let coinSymbols: [(key: String, apiSymbol: String)] = [
        ("btc", "BTC"),
        ("eth", "ETH"),
        ("tron", "TRX"),
        ("luna", "LUNA"),
        ("polkadot", "DOT"),
        ("dogecoin", "DOGE"),
        ("tether", "USDT"),
        ("stellar", "XLM"),
        ("cardano", "ADA"),
        ("xrp", "XRP")
    ]

    var coins: [CoinMetricsData] = [] {
        didSet {
            self.cellModels = self.coins.map { CoinCellModel(coin: $0) }
            onCoinsUpdated?(true)
        }
    }

    var onError: ((Error) -> Void)?
    var onCoinsUpdated: ((Bool) -> Void)?
    
    func fetchCoins() {
        onCoinsUpdated?(true)
        let apiSymbols = coinSymbols.map { $0.apiSymbol }
        
        coinService.fetchMetrics(for: apiSymbols) { [weak self] coins in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let sortedCoins = self.coinSymbols.compactMap { pair -> CoinMetricsData? in
                    coins.first { $0.symbol.lowercased() == pair.apiSymbol.lowercased() }
                }
                self.coins = sortedCoins
                self.originalCoins = sortedCoins
                self.cellModels = sortedCoins.map { CoinCellModel(coin: $0) }
                self.onCoinsUpdated?(false)
            }
        }
    }
    
    func sortCoins(by direction: SortDirection) {
        switch direction {
        case .more:
            coins.sort {
                $0.marketData.percentChangeUSDLast24Hours < $1.marketData.percentChangeUSDLast24Hours
            }
        case .less:
            coins.sort {
                $0.marketData.percentChangeUSDLast24Hours > $1.marketData.percentChangeUSDLast24Hours
            }
        case .none:
            coins = originalCoins
        }

        self.cellModels = self.coins.map { CoinCellModel(coin: $0) }
        self.onCoinsUpdated?(false)
    }
}
