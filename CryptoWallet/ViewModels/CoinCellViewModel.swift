import Foundation
import UIKit

final class CoinCellViewModel {
    private let model: CoinCellModel
    private let currencyFormatter: NumberFormatter
    private let decimalFormatter: NumberFormatter

    init(model: CoinCellModel) {
        self.model = model

        currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")

        decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = 2
    }

    var fullName: String {
        model.fullName
    }

    var shortName: String {
        model.shortName
    }

    var price: String {
        currencyFormatter.string(from: NSNumber(value: model.priceUSD)) ?? "–"
    }

    var percentChange: String {
        String(format: "%.2f%%", abs(model.percentChange24h))
    }

    var changeIconName: String {
        model.percentChange24h >= 0 ? "arrowUp" : "arrowDown"
    }

    var marketCap: String {
        guard let marketCap = model.marketCapUSD else { return "–" }
        return currencyFormatter.string(from: NSNumber(value: marketCap)) ?? "–"
    }

    var circulatingSupplyInCoins: String {
        guard
            let supplyUSD = model.circulatingSupply,
            model.priceUSD > 0
        else {
            return "–"
        }

        let supplyInCoins = supplyUSD / model.priceUSD
        let formatted = decimalFormatter.string(from: NSNumber(value: supplyInCoins)) ?? "–"
        
        return "\(formatted) \(model.shortName)"
    }
    var coinImage: UIImage? {
        UIImage(named: shortName.lowercased())
    }
}
