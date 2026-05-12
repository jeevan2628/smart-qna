//
//  LinearProgressBar.swift
//  SmartQnA
//
//  Created by Jeevan on 23/04/26.
//

import SwiftUI

struct LinearProgressBar: View {
	var progress: Double // 0.0 → 1.0
	
	var backgroundColor: Color = Color.gray.opacity(0.2)
	var progressColor: Color = .blue
	var height: CGFloat = 12
	var showPercentage: Bool = true
	
	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			
			// Progress
			GeometryReader { geo in
				Capsule()
					.fill(progressColor)
					.frame(width: geo.size.width * progress, height: height)
					.animation(.easeInOut, value: progress)
			}
			// Percentage label
			if showPercentage {
				Text("Model download progress: \(Int(progress * 100))%")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			
		}
		.frame(height: 35)
	}
}

#Preview {
    LinearProgressBar(progress: 0.5)
}
