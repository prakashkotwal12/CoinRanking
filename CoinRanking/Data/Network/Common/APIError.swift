//
//  APIError.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//
enum APIError: Error, Equatable {
    case invalidURL
    case decodingError
    case serverError(String)
    case unknownError(String)
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
            case (.invalidURL, .invalidURL):
                return true
            case (.decodingError, .decodingError):
                return true
            case (.serverError(let lhsMessage), .serverError(let rhsMessage)):
                return lhsMessage == rhsMessage
            case (.unknownError(let lhsMessage), .unknownError(let rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
        }
    }    
}
