//
//  CoinResponseModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//

struct CoinResponseModel: Codable {
    let status: String
    let data: CoinDataModel
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            status = try container.decode(String.self, forKey: .status)
        } catch {
            print("❌ Error decoding 'status': \(error.localizedDescription)")
            throw error
        }
        
        do {
            data = try container.decode(CoinDataModel.self, forKey: .data)
        } catch {
            print("❌ Error decoding 'data': \(error.localizedDescription)")
            throw error
        }
    }    
}
