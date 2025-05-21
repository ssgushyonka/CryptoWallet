import Foundation

final class CoinRatesViewModel {
    private let coinService = CoinMetricsService()
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
            onCoinsUpdated?()
        }
    }
    
    var onCoinsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchCoins() {
        let apiSymbols = coinSymbols.map { $0.apiSymbol }
        
        coinService.fetchMetrics(for: apiSymbols) { [weak self] coins in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let sortedCoins = self.coinSymbols.compactMap { pair -> CoinMetricsData? in
                    coins.first { $0.symbol.lowercased() == pair.apiSymbol.lowercased() }
                }
                
                // Используй инициализатор из CoinCellModel
                let models = sortedCoins.map { CoinCellModel(coin: $0) }
                
                // Обновляем coins именно с моделями для таблицы
                self.cellModels = models
                self.onCoinsUpdated?()
            }
        }
    }

}
