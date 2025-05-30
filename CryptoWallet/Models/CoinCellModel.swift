import Foundation

struct CoinCellModel {
    let fullName: String
    let shortName: String
    let priceUSD: Double
    let percentChange24h: Double
    let marketCapUSD: Double?
    let circulatingSupply: Double?
    
    init(coin: CoinMetricsData) {
        self.fullName = coin.name
        self.shortName = coin.symbol.uppercased()
        self.priceUSD = coin.marketData.priceUSD
        self.percentChange24h = coin.marketData.percentChangeUSDLast24Hours
        self.marketCapUSD = coin.marketcap.currentMarketcapUSD
        self.circulatingSupply = coin.supply.circulating
    }
}
