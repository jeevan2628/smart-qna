//
//  RoundedCardModifier.swift
//  SmartQnA
//
//  Created by Jeevan on 23/04/26.
//

import SwiftUI

struct RoundedCardModifier: ViewModifier {
	var backgroundColor: Color = Color(.systemBackground)
	var cornerRadius: CGFloat = 16
	var shadowColor: Color = .black.opacity(0.1)
	
	func body(content: Content) -> some View {
		content
			.padding()
			.background(
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.fill(backgroundColor)
			)
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.stroke(Color.gray.opacity(0.1), lineWidth: 1)
			)
			.shadow(color: shadowColor, radius: 8, x: 0, y: 4)
	}
}

extension View {
	func roundedCardStyle(
		backgroundColor: Color = Color(.systemBackground),
		cornerRadius: CGFloat = 16
	) -> some View {
		self.modifier(
			RoundedCardModifier(
				backgroundColor: backgroundColor,
				cornerRadius: cornerRadius
			)
		)
	}
}
