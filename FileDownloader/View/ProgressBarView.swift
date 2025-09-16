import SwiftUI

struct ProgressBarView: View {
    
    let progress: Double
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.orange)
                    .frame(width: (proxy.size.width / 100) * CGFloat(progress), height: 8)
                    .animation(.easeInOut(duration: 0.1), value: progress)
            }
        }
    }
}

#Preview {
    ProgressBarView(progress: 85)
}
