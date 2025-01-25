//
//  NetworkManager.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import Alamofire
//import SwiftyJSON
// MARK: - Protocols
protocol NetworkManagerProtocol {
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinData, Error>) -> Void)
}

// MARK: - NetworkManager
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.coinranking.com/v2/"
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinData, Error>) -> Void) {
        let params: [String: Any] = [
            "limit": limit,
            "offset": offset
        ]
        AF.request(baseUrl + "coins",
                   method: .get,
                   parameters: params)
            .validate()
            .responseDecodable(of: CoinResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                        completion(.success(data.data))
                case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
