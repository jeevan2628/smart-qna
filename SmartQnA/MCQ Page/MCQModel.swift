//
//  MCQModel.swift
//  SmartQnA
//
//  Created by Jeevan on 21/04/26.
//

import Foundation

final class MCQModel {
	let question: String?
	let options: [String]?
	let answer: Int?
	let explanation: String?

	init(question: String?, options: [String]? = nil, answer: Int?, explanation: String? = nil) {
		self.question = question
		self.options = ["Yes", "No"]
		self.answer = answer
		self.explanation = explanation
	}
}

extension MCQModel {

	static func parseMCQ(from pipe: String) -> MCQModel? {
		print("pipe: \(pipe)")
		let parts = pipe
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.components(separatedBy: "|")

		// Validate field count
		guard parts.count == 2 else {
			print("Invalid format: expected 2 fields, got \(parts.count)")
			return nil
		}

		let cleaned = parts.map {
			$0.trimmingCharacters(in: .whitespaces)
		}

		let question = cleaned[0]
		let answerRaw = cleaned[1].uppercased()

		// Validate answer (Y/N)
		let answer: Bool
		switch answerRaw {
		case "Y":
			answer = true
		case "N":
			answer = false
		default:
			print("Invalid answer: \(answerRaw)")
			return nil
		}

		// Extra safety checks
		guard !question.isEmpty else {
			print("Empty question")
			return nil
		}

		return MCQModel(
			question: question,
			answer: answer ? 1 : 0,
		)
	}

//	static func parseMCQ(from pipe: String) -> MCQModel? {
//		let parts = pipe
//			.trimmingCharacters(in: .whitespacesAndNewlines)
//			.components(separatedBy: "|")
//		
//		// Validate field count
//		guard parts.count == 7 else {
//			print("Invalid format: expected 7 fields, got \(parts.count)")
//			return nil
//		}
//		
//		let cleaned = parts.map {
//			$0.trimmingCharacters(in: .whitespaces)
//		}
//		
//		let question = cleaned[0]
//		
//		let options = [
//			cleaned[1],
//			cleaned[2],
//			cleaned[3],
//			cleaned[4]
//		]
//		
//		let answerLetter = cleaned[5].uppercased()
//		let explanation = cleaned[6]
//		
//		// Convert A/B/C/D → index
//		let answerIndex: Int?
//		switch answerLetter {
//		case "A": answerIndex = 0
//		case "B": answerIndex = 1
//		case "C": answerIndex = 2
//		case "D": answerIndex = 3
//		default:
//			print("Invalid answer: \(answerLetter)")
//			return nil
//		}
//		
//		// Extra safety checks
//		guard options.allSatisfy({ !$0.isEmpty }) else {
//			print("Empty option found")
//			return nil
//		}
//		
//		return MCQModel(
//			question: question,
//			options: options,
//			answer: answerIndex,
//			explanation: explanation
//		)
//	}
}
