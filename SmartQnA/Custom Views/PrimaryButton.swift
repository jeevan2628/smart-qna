//
//  PrimaryButton.swift
//  SmartQnA
//
//  Created by Jeevan on 21/04/26.
//

import SwiftUI

struct PrimaryButton: View {
	let title: String
	var backgroundColor: Color = .brown
	var textColor: Color = .white
	let action: () -> Void
	
	var body: some View {
		Button(action: {
			action()
		}) {
			ZStack {
				
				// Title (hidden when loading to keep size)
				Text(title.uppercased())
					.font(.body.weight(.semibold))
				
			}
			.frame(maxWidth: .infinity)
			.padding()
			.foregroundStyle(textColor)
			.background(backgroundColor)
			.clipShape(Capsule())
		}
	}
}

#Preview {
	PrimaryButton(title: "Submit") {
		//
	}
}
