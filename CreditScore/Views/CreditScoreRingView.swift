import SwiftUI

struct CreditScoreRingView: View {
    let score: Int
    let maxScore: Int
    
    private var progress: Double {
        min(max(Double(score) / Double(maxScore), 0), 1)    }
    
    init(score: Int, maxScore: Int) {
        self.score = score
        self.maxScore = maxScore
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.orange,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            VStack {
                Text("Your credit score is")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(score)")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.orange)
                Text("out of \(maxScore)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 250, height: 250)
    }
}

#Preview("Different Scores") {
    VStack(spacing: 20) {
        CreditScoreRingView(score: 327, maxScore: 700)
        CreditScoreRingView(score: 700, maxScore: 700)
        CreditScoreRingView(score: 100, maxScore: 700)
    }
}
