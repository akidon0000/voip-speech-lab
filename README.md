# VoIP Speech Lab

A prototype iOS + watchOS application demonstrating real-time voice analysis and client information display during VoIP calls.

## Features

- **VoIP Call Simulation**: Uses AVAudioEngine to capture microphone input simulating VoIP calls
- **Real-time Speech Recognition**: Transcribes outgoing voice using iOS Speech framework
- **Client Name Detection**: Analyzes transcribed text for mentions of customer names
- **Apple Watch Integration**: Displays relevant client information on Apple Watch when names are detected
- **WatchConnectivity**: Seamless communication between iPhone and Apple Watch

## Architecture

### iOS App Components
- `VoIPSpeechLabApp.swift`: Main app entry point
- `ContentView.swift`: Primary UI with call simulation and transcription display
- `SpeechRecognitionManager.swift`: Handles real-time speech recognition using AVAudioEngine
- `ClientDataManager.swift`: Manages client data loading and name detection
- `WatchConnectivityManager.swift`: Handles communication with Apple Watch
- `ClientInfo.swift`: Data model for client information

### watchOS App Components
- `VoIPSpeechLabWatch.swift`: Watch app entry point
- `WatchContentView.swift`: Watch UI displaying client information
- `WatchConnectivityManager.swift`: Receives client data from iPhone
- `ClientInfo.swift`: Shared data model

### Client Data
- `test_clients.json`: Mock client database with detailed information for Alice Yamada and Bob Tanaka

## Usage

1. Launch the iOS app and grant microphone and speech recognition permissions
2. Tap "Start Call" to begin voice recognition
3. Speak client names like "Alice Yamada" or "Bob Tanaka"
4. Watch the Apple Watch display relevant client information automatically

## Requirements

- iOS 17.0+
- watchOS 10.0+
- Xcode 15.0+
- Paired Apple Watch for full functionality

## Pipeline Flow

Voice Input → Speech Recognition → Client Name Detection → WatchConnectivity → Apple Watch Display
