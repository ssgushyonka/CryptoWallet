import Foundation

struct CoinMetricsResponse: Codable {
    let data: CoinMetricsData
}

struct CoinMetricsData: Codable {
    let symbol: String
    let name: String
    let marketData: MarketData

    enum CodingKeys: String, CodingKey {
        case symbol, name
        case marketData = "market_data"
    }
}

struct MarketData: Codable {
    let priceUSD: Double
    let percentChangeUSDLast24Hours: Double
    
    enum CodingKeys: String, CodingKey {
        case priceUSD = "price_usd"
        case percentChangeUSDLast24Hours = "percent_change_usd_last_24_hours"
    }
}
