import Foundation

final class CoinMetricsService {
    private let session = URLSession.shared
    private let baseURL = "https://data.messari.io/api/v1/assets/"
    
    func fetchMetrics(for symbols: [String], completion: @escaping ([CoinMetricsData]) -> Void) {
        let group = DispatchGroup()
        var result: [CoinMetricsData] = []
        
        for symbol in symbols {
            group.enter()
            let urlString = "\(baseURL)\(symbol)/metrics"
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }
            
            session.dataTask(with: url) { data, _, error in
                defer { group.leave() }
                guard
                    let data = data,
                    error == nil,
                    let response = try? JSONDecoder().decode(CoinMetricsResponse.self, from: data)
                else {
                    return
                }
                result.append(response.data)
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion(result)
        }
    }
}
