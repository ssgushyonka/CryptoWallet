import Foundation

final class CoinDetailViewModel {
    let coinModel: CoinCellModel
    
    var coinName: String {
        return "\(coinModel.fullName) (\(coinModel.shortName))"
    }

    init(coinModel: CoinCellModel) {
        self.coinModel = coinModel
    }
}
