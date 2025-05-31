import SwiftUI

struct ContentView: View {
    @StateObject private var speechManager = SpeechRecognitionManager()
    @StateObject private var clientDataManager = ClientDataManager()
    @StateObject private var watchConnectivity = WatchConnectivityManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("VoIP Speech Lab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text("Simulated VoIP Call")
                            .font(.headline)
                    }
                    
                    Button(action: {
                        if speechManager.isRecording {
                            speechManager.stopRecording()
                        } else {
                            speechManager.startRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: speechManager.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            Text(speechManager.isRecording ? "Stop Call" : "Start Call")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(speechManager.isRecording ? Color.red : Color.green)
                        .cornerRadius(10)
                    }
                    .disabled(speechManager.authorizationStatus != .authorized)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Live Transcription")
                        .font(.headline)
                    
                    ScrollView {
                        Text(speechManager.transcribedText.isEmpty ? "Speak to see transcription..." : speechManager.transcribedText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .frame(height: 120)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "applewatch")
                        Text("Watch Connection")
                            .font(.headline)
                        Spacer()
                        Circle()
                            .fill(watchConnectivity.isConnected ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                    }
                    
                    if let client = watchConnectivity.lastSentClient {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Last sent to watch:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(client.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(client.company)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
                if speechManager.authorizationStatus != .authorized {
                    VStack {
                        Text("Speech Recognition Permission Required")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text("Please enable speech recognition in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                Text("Try saying: \"Alice Yamada\" or \"Bob Tanaka\"")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
