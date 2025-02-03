import Foundation

/// Represents the main credit score data model
/// Conforms to Codable for JSON parsing
struct CreditScoreResponse: Codable {
    
    /// Status of the account verification process
    /// Possible values: "PASS", "FAIL", "PENDING"
    let accountIDVStatus: String
    
    /// Detailed information about the user's credit report
    let creditReportInfo: CreditReportInfo
    
    struct CreditReportInfo: Codable {
        /// Current credit score value
        /// - Note: Should be between minScoreValue and maxScoreValue
        let score: Int
        
        /// Maximum possible credit score
        /// - Note: Typically 700 for this system
        let maxScoreValue: Int
        
        /// Minimum possible credit score
        /// - Note: Typically 0 for this system
        let minScoreValue: Int
        
        /// Band classification of the score (0-7)
        /// - Note: Higher bands indicate better credit ratings
        let scoreBand: Int
    }
}
