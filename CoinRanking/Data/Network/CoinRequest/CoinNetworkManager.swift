//
//  CoinNetworkManager.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//
final class CoinNetworkManager: CoinNetworkManagerProtocol {
    static let shared = CoinNetworkManager()
    
    private let networkManager: NetworkManagerProtocol
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinDataModel, APIError>) -> Void) {
        let params: [String: Any] = ["limit": limit, "offset": offset]
        networkManager.performRequest(endpoint: "coins", method: .get, parameters: params) { (result: Result<CoinResponseModel, APIError>) in
            switch result {
                case .success(let responseModel):
                    completion(.success(responseModel.data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }    
}
