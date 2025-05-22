import Foundation

struct CoinCellModel {
    let fullName: String
    let shortName: String
    let price: String
    let percentChange: String
    let changeIconName: String
    let marketCap: String
    let circulatingSupply: String

    init(coin: CoinMetricsData) {
        fullName = coin.name
        shortName = coin.symbol.uppercased()

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")

        price = formatter.string(from: NSNumber(value: coin.marketData.priceUSD)) ?? "–"
        percentChange = String(format: "%.2f%%", abs(coin.marketData.percentChangeUSDLast24Hours))
        changeIconName = coin.marketData.percentChangeUSDLast24Hours >= 0 ? "arrowUp" : "arrowDown"

        marketCap = coin.marketcap.currentMarketcapUSD
            .flatMap { formatter.string(from: NSNumber(value: $0)) } ?? "–"

        circulatingSupply = coin.supply.circulating
            .flatMap { formatter.string(from: NSNumber(value: $0)) } ?? "–"
    }
}
