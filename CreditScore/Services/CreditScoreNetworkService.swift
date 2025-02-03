import Foundation
import SwiftUI

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case timeout
}

protocol NetworkServiceProtocol {
    func retreiveCreditScore() async throws -> CreditScoreResponse
}

class CreditScoreNetworkService: NetworkServiceProtocol {
    private let baseURL = "https://android-interview.s3.eu-west-2.amazonaws.com/endpoint.json"
    
    func retreiveCreditScore() async throws -> CreditScoreResponse {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(CreditScoreResponse.self, from: data)
            
        } catch {
            if let nsError = error as NSError?, nsError.code == NSURLErrorTimedOut {
                throw NetworkError.timeout
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
}
