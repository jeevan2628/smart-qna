//
//  MCQView.swift
//  SmartQnA
//
//  Created by Jeevan on 20/04/26.
//

import SwiftUI

struct MCQView: View {
	private var model: MCQModel
	private let question: String?
	private let options: [String]?
	private let anwer: Int?
	
	init(model: MCQModel) {
		self.model = model
		self.question = model.question
		self.options = model.options
		self.anwer = model.answer
	}
	
	@State private var selectedIndex: Int? = nil
	@State private var showAlert = false
	@State private var isCorrect = false
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 48) {
				
				// Question
				Text(question ?? "n/a")
					.font(.headline)
					.multilineTextAlignment(.leading)
					.fixedSize(horizontal: false, vertical: true)
				
				// Options
				VStack(alignment: .leading, spacing: 16) {

					if let options {
						ForEach(options.indices, id: \.self) { index in
							OptionRow(
								text: options[index],
								isSelected: selectedIndex == index
							) {
								selectedIndex = index
							}
							.roundedCardStyle()
						}
					}
				}
				
				PrimaryButton(title: "Submit".uppercased(),
											backgroundColor: Color.brown,
											textColor: Color.white, action: {
					guard let selected = selectedIndex else { return }
					
					isCorrect = (selected == anwer)
					showAlert = true

				})
				.disabled(selectedIndex == nil)
				
			}
			.alert(isCorrect ? "Correct 🎉" : "Wrong ❌", isPresented: $showAlert) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(isCorrect
						 ? "You selected the right answer."
						 : "Correct answer is option \(["A","B","C","D"][anwer ?? 0]).")
			}
			.padding()
		}
	}
}

struct OptionRow: View {
	let text: String
	let isSelected: Bool
	let onTap: () -> Void
	
	var body: some View {
		HStack(spacing: 12) {
			
			// Radio Button
			ZStack {
				Circle()
					.stroke(isSelected ? Color.brown : Color.gray, lineWidth: 2)
					.frame(width: 20, height: 20)
				
				if isSelected {
					Circle()
						.fill(Color.brown)
						.frame(width: 10, height: 10)
				}
			}
			
			// Option Text
			Text(text)
				.foregroundColor(.primary)
			
			Spacer()
		}
		.contentShape(Rectangle())
		.onTapGesture {
			onTap()
		}
		.padding(.vertical, 8)
	}
}

#Preview {
	MCQView(model: MCQModel(
		question: "Test question",
		options: ["a1", "a2", "a3", "a4"],
		answer: 2,
		explanation: "explain")
	)
}
