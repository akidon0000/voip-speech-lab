//
//  ContentView.swift
//  voip-speech-lab
//
//  Created by Akihiro Matsuyama on 2025/05/31.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioEngine = VoIPAudioEngine()
    @StateObject private var clientManager = ClientManager()
    @StateObject private var nameDetection = NameDetectionService(clientManager: ClientManager())
    @StateObject private var watchConnectivity = WatchConnectivityManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("VoIP Speech Lab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 10) {
                    HStack {
                        Circle()
                            .fill(watchConnectivity.isWatchConnected ? .green : .red)
                            .frame(width: 12, height: 12)
                        Text("Watch: \(watchConnectivity.isWatchConnected ? "Connected" : "Disconnected")")
                            .font(.caption)
                    }
                    
                    HStack {
                        Circle()
                            .fill(audioEngine.permissionStatus == .granted ? .green : .red)
                            .frame(width: 12, height: 12)
                        Text("Permissions: \(audioEngine.permissionStatus == .granted ? "Granted" : "Required")")
                            .font(.caption)
                    }
                }
                
                if audioEngine.permissionStatus != .granted {
                    Button("Request Permissions") {
                        Task {
                            await audioEngine.requestPermissions()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                VStack(spacing: 15) {
                    Button(action: {
                        if audioEngine.isRecording {
                            audioEngine.stopRecording()
                        } else {
                            audioEngine.startRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: audioEngine.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.title2)
                            Text(audioEngine.isRecording ? "Stop Recording" : "Start VoIP Call")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(audioEngine.permissionStatus != .granted)
                    
                    if audioEngine.isRecording {
                        HStack {
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                            Text("Recording...")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        if !audioEngine.transcribedText.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Transcription:")
                                    .font(.headline)
                                Text(audioEngine.transcribedText)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        if let client = nameDetection.detectedClient {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Detected Client:")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(client.name)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("\(client.data.position) at \(client.data.company)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Next Meeting: \(client.data.nextMeeting)")
                                        .font(.caption)
                                    Text("Deal Value: ¥\(client.data.dealValue.formatted())")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                                
                                if let lastSent = watchConnectivity.lastSentClient {
                                    Text("✓ Sent to Watch: \(lastSent)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onAppear {
            audioEngine.onTranscriptionUpdate = { text in
                nameDetection.analyzeText(text)
                
                if let client = nameDetection.detectedClient {
                    watchConnectivity.sendClientInfo(client)
                }
            }
        }
    }
}
