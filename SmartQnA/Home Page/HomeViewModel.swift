//
//  HomeViewModel.swift
//  SmartQnA
//
//  Created by Jeevan on 30/03/26.
//

import Foundation
import MLX
import MLXLinalg
import MLXLLM
import MLXLMCommon
import MLXRandom
import Foundation
import Combine
import SwiftUI
internal import Tokenizers

@MainActor
class HomeViewModel: ObservableObject {
	@Published var output = ""
	@Published var running = false
	@Published var isQuestionReady = false
	@Published var isStarted = false
	@Published var showDetail = false
	@Published var downloadProgress: Double = 0.0

	private let modelConfig = ModelRegistry.llama3_2_1B_4bit
	private let parameters = GenerateParameters(temperature: 0.7)
	private var modelContainer: ModelContainer? = nil
	
	var model: MCQModel? {
		return MCQModel.parseMCQ(from: output)
	}
	
	func loadModel() async throws {
		guard modelContainer == nil else { return }
		// let modelConfig = ModelConfiguration(directory: URL.cachesDirectory.appendingPathComponent("models/mlx-community/Llama-3.2-3B-Instruct-4bit"))
				
//		MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
		print("Model directory: ")
		print(modelConfig.modelDirectory())
				
		modelContainer = try await LLMModelFactory.shared.loadContainer(
			configuration: modelConfig
		) { progress in
			Task { @MainActor in
				self.downloadProgress = progress.fractionCompleted
			}
			print("Downloading model: \(Int(progress.fractionCompleted * 100))%")
		}
	}
	
	func generate(prompt: String = "",
								systemPrompt: String = """
You are a teacher.

Generate exactly ONE Yes or No question about the Indian flag.

Return output as EXACTLY ONE line using '|' as separator with 2 fields.

Rules:

Output must be a SINGLE LINE only
Use '|' as the ONLY separator
Do not add extra separators
Do not add extra text before or after
Do not use '|' inside any field
Do not use commas or quotes
If needed rephrase to avoid special characters

Field format:
<question>|<answer either Y or N>

Constraints:

answer must be exactly Y or N
question must be clear and unambiguous

Output ONLY the single line. Nothing else.
"""
	) async {
		guard !running else { return }
		running = true
		output = "Generating..."
		
		do {
			try await loadModel()
			
			let result = try await modelContainer!.perform { context in
				let input = try await context.processor.prepare(
					input: .init(messages: [
						["role": "system", "content": systemPrompt],
						["role": "user", "content": prompt]
					])
				)
				
				return try MLXLMCommon.generate(
					input: input,
					parameters: parameters,
					context: context
				) { tokens in
					let partial = context.tokenizer.decode(tokens: tokens)
					Task { @MainActor in self.output = partial }
					return tokens.count >= 1000 ? .stop : .more
				}
			}
			
			output = result.output
			isQuestionReady = true
			print("output: \(output) \n")
	 
		} catch {
			output = "Error: \(error.localizedDescription)"
		}
		
		running = false
	}
}
//class SmartViewModel {
//	
//	func performActionOnPrompt() {
////		let path = Bundle.main.path(forResource: "Phi-3-mini-4k-instruct-q4", ofType: "gguf")!
////		let llm = LlamaWrapper(modelPath: path)
////		let prompt = """
////Generate 1 MCQ for topic: Photosynthesis
////"""
////	
////		let result = llm.generate(prompt)
////		print(result)
//		
//		// Initialize model
////		let model = try Model(modelPath: path)
////		let llama = try LLama(model: model)
////		
////		// Results are delivered through an `AsyncStream`
////		let prompt = "what is the meaning of life?"
////		for try await token in await llama.infer(prompt: prompt, maxTokens: 1024) {
////			print(token, terminator: "")
////		}
//	}
//}

/*
 You are a teacher.
 
 Generate exactly ONE multiple choice question about the Indian flag.
 
 Return ONLY valid JSON. Do NOT include any explanation, text, markdown, or characters outside the JSON.
 
 Follow this schema strictly:
 - question: string
 - options: array of exactly 4 objects
 - each option must have:
 - id: one of "A", "B", "C", "D"
 - text: string
 - correctAnswer: must be one of "A", "B", "C", or "D"
 - explanation: string
 
 Rules:
 - Do not change the structure
 - Do not add extra fields
 - Do not reorder keys
 - Ensure valid JSON (no trailing commas)
 
 Output JSON format:

 
 {
 "question": "",
 "options": [
 { "id": "A", "text": "" },
 { "id": "B", "text": "" },
 { "id": "C", "text": "" },
 { "id": "D", "text": "" }
 ],
 "correctAnswer": "",
 "explanation": ""
 }
 */
