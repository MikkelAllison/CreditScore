import SwiftUI

struct CreditScoreRootView: View {
    @StateObject private var viewModel = CreditScoreViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let error = viewModel.error {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Try Again") {
                        Task {
                            await viewModel.fetchCreditScore()
                        }
                    }
                }
            } else if let creditScore = viewModel.creditScore {
                CreditScoreRingView(
                    score: creditScore.creditReportInfo.score,
                    maxScore: creditScore.creditReportInfo.maxScoreValue
                )
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCreditScore()
            }
        }
    }
}

#Preview {
    CreditScoreRootView()
}
