//
//  ContentView.swift
//  AudioContentAnalyzer
//
//  Created by Erick Ribeiro on 17/03/24.
//

import SwiftUI
import OffensiveAudioClassifier

struct ContentView: View {
    @StateObject var offensiveClassifier = OffensiveAudioClassifier()
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            
            Text(offensiveClassifier.textOffensive)
                .font(.title)
                .foregroundStyle(offensiveClassifier.textOffensive == "neither" ? .blue : .red)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(offensiveClassifier.textOffensive == "neither" ? .blue : .red, lineWidth: 1)

                Text(offensiveClassifier.transcript)
                    .frame(maxHeight: .infinity)
                    .foregroundStyle(.primary)
                    .padding()
                    .onChange(of: offensiveClassifier.transcript) {
                        if !isRecording {
                            offensiveClassifier.detectOffensive(message: offensiveClassifier.transcript)
                        }
                    }
                    .disabled(isRecording)

            }
            .frame(maxHeight: 300)
            .padding()
            .padding(.bottom, 80)

            Button(action: {
                if !isRecording {
                    offensiveClassifier.textOffensive = "neither"
                    offensiveClassifier.transcript = ""
                    offensiveClassifier.transcribe()
                    
                } else {
                    offensiveClassifier.stopTranscribing()
                }
                
                isRecording.toggle()
                
            }) {
                Circle()
                    .fill(Color(.pink))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .foregroundStyle(.white)
                            .font(.title2)
                    )
            }
        }
    }
}

#Preview {
    ContentView()
}
