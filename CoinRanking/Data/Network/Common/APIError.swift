//
//  APIError.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//
enum APIError: Error {
    case invalidURL
    case decodingError
    case serverError(String)
    case unknownError(String)    
}
