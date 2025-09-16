//
//  ProgressView.swift
//  FileDownloader
//
//  Created by Gopabandhu Dash on 15/09/25.
//

import SwiftUI

struct ProgressView: View {
    @State private var isAnimating = false
    
    let progress: String
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .trim(from: 0.2, to: 1)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            
            Text("\(progress) %")
                .font(.title3)
                .bold()
        }
    }
}

#Preview {
    ProgressView(progress: "67")
}
