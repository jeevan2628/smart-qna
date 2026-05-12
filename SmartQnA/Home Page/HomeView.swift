//
//  HomeView.swift
//  SmartQnA
//
//  Created by Jeevan on 08/03/26.
//

import SwiftUI
import FoundationModels

/// Initial page after launch which will help to initiate the AI model and pass the querry result to next page.
struct HomeView: View {
	
	@StateObject var viewModel = HomeViewModel()
	@State private var result = ""
	@State private var userPrompt = ""
	
	var body: some View {
		
		VStack {
			
			Image("placeholder")
				.resizable()
				.aspectRatio(contentMode: .fit)
			
			VStack {
				if !viewModel.isStarted {
					
					PrimaryButton(title: "Load Quiz".uppercased(),
												backgroundColor: Color.blue,
												textColor: Color.white,
												action: {
						viewModel.isStarted = true
						Task {
							await viewModel.generate(prompt: userPrompt)
						}
						
					})
				} else if viewModel.isQuestionReady {
					PrimaryButton(title: "Start Quiz".uppercased(),
												backgroundColor: Color.brown,
												textColor: Color.white, action: {
						viewModel.showDetail = true
					})
				}

//				if viewModel.isStarted {
//					LinearProgressBar(progress: 0.0)
//				}

				if viewModel.isStarted && !viewModel.isQuestionReady {
					LinearProgressBar(progress: viewModel.downloadProgress)
				}
				
				ScrollView {
					Text(viewModel.output)
						.padding()
				}
				
			}.padding()
		}
		.navigationDestination(isPresented: $viewModel.showDetail) {
			if let model = viewModel.model, viewModel.isQuestionReady {
				MCQView(model: model)
			}
		}
		.navigationTitle("AI Quiz Generator")
		.padding()
	}
}
