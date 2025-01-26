//
//  NetworkManager.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Alamofire
import Foundation

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() { }
    
    func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: APIConstants.baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url,
                   method: Alamofire.HTTPMethod(rawValue: method.rawValue),
                   parameters: parameters)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let data = response.data,
                       let serverMessage = String(data: data, encoding: .utf8) {
                        completion(.failure(.serverError(serverMessage)))
                    } else {
                        completion(.failure(.unknownError(error.localizedDescription)))
                    }
            }
        }
    }
}
