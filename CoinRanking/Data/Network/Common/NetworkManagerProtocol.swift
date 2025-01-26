//
//  NetworkManagerProtocol.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//
import Foundation

protocol NetworkManagerProtocol {
    func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        completion: @escaping (Result<T, APIError>) -> Void
    )    
}
