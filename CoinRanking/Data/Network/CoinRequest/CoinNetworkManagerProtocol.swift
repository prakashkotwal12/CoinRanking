//
//  CoinNetworkManagerProtocol.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//
protocol CoinNetworkManagerProtocol {
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinDataModel, APIError>) -> Void)    
}
