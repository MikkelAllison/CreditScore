import XCTest

@testable import CreditScore

class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed: Bool
    var score: Int
    var shouldSimulateTimeout: Bool
    var delay: TimeInterval = 0
    
    init(shouldSucceed: Bool = true, score: Int = 514, shouldSimulateTimeout: Bool = false, delay: TimeInterval = 0) {
        self.shouldSucceed = shouldSucceed
        self.score = score
        self.shouldSimulateTimeout = shouldSimulateTimeout
        self.delay = delay
    }
    
    func retreiveCreditScore() async throws -> CreditScoreResponse {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if shouldSimulateTimeout {
            throw NetworkError.timeout
        }
        
        if shouldSucceed {
            return CreditScoreResponse(
                accountIDVStatus: "PASS",
                creditReportInfo: .init(
                    score: score,
                    maxScoreValue: 700,
                    minScoreValue: 0,
                    scoreBand: 4
                )
            )
        } else {
            throw NetworkError.invalidResponse
        }
    }
}

@MainActor
class CreditScoreViewModelTests: XCTestCase {
    var viewModel: CreditScoreViewModel!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testMinimumScore() async {
        let mockService = MockNetworkService(shouldSucceed: true, score: 0)
        viewModel = CreditScoreViewModel(networkService: mockService)
        
        await viewModel.fetchCreditScore()
        
        let score = viewModel.creditScore?.creditReportInfo.score
        XCTAssertEqual(score, 0)
    }
    
    func testMaximumScore() async {
        let mockService = MockNetworkService(shouldSucceed: true, score: 700)
        viewModel = CreditScoreViewModel(networkService: mockService)
        
        await viewModel.fetchCreditScore()
        
        let score = viewModel.creditScore?.creditReportInfo.score
        XCTAssertEqual(score, 700)
    }

    func testTimeout() async {
        let mockService = MockNetworkService(shouldSimulateTimeout: true)
        viewModel = CreditScoreViewModel(networkService: mockService)
        
        await viewModel.fetchCreditScore()
        
        let error = viewModel.error
        XCTAssertNotNil(error)
        XCTAssertEqual(error, "Request timed out. Please try again.")
    }
    
    func testNetworkFailure() async {
           let mockService = MockNetworkService(shouldSucceed: false)
           viewModel = CreditScoreViewModel(networkService: mockService)
           
           await viewModel.fetchCreditScore()
           
           XCTAssertNotNil(viewModel.error)
           XCTAssertEqual(viewModel.error, "Received an invalid response from the server.")
       }
       
       func testInvalidJSONResponse() async {
           class InvalidJSONMockService: NetworkServiceProtocol {
               func retreiveCreditScore() async throws -> CreditScoreResponse {
                   throw DecodingError.dataCorrupted(DecodingError.Context(
                       codingPath: [],
                       debugDescription: "Invalid JSON"
                   ))
               }
           }
           
           viewModel = CreditScoreViewModel(networkService: InvalidJSONMockService())
           await viewModel.fetchCreditScore()
           
           XCTAssertNotNil(viewModel.error)
           XCTAssertEqual(viewModel.error, "The data couldn’t be read because it isn’t in the correct format.")
       }
   }
