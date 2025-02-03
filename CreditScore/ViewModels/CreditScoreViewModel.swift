import Foundation
import SwiftUI

@MainActor
class CreditScoreViewModel: ObservableObject {
    @Published private(set) var creditScore: CreditScoreResponse?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = CreditScoreNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCreditScore() async {
        isLoading = true
        error = nil
        do {
                creditScore = try await networkService.retreiveCreditScore()
            } catch let fetchError {
                
                if let netError = fetchError as? NetworkError {
                           switch netError {
                           case .invalidURL:
                               error = "The URL is invalid."
                           case .invalidResponse:
                               error = "Received an invalid response from the server."
                           case .invalidData:
                               error = "Failed to decode the data properly."
                           case .timeout:
                               error = "Request timed out. Please try again."
                           case .networkError(let underlying):
                               error = "A network error occurred: \(underlying.localizedDescription)"
                           }
                       } else {
                           error = fetchError.localizedDescription
                       }
                   }
                   isLoading = false
    }
}
