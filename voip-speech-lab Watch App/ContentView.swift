import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Text("VoIP Speech Lab")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Circle()
                            .fill(watchConnectivity.isConnected ? .green : .red)
                            .frame(width: 8, height: 8)
                        Text(watchConnectivity.isConnected ? "Connected" : "Disconnected")
                            .font(.caption2)
                    }
                    
                    if let client = watchConnectivity.currentClient {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Client Detected")
                                .font(.caption)
                                .foregroundColor(.green)
                            
                            Text(client.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(client.company)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(client.position)
                                .font(.caption2)
                            
                            if !client.nextMeeting.isEmpty {
                                Text("Next: \(client.nextMeeting)")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                            
                            if client.dealValue > 0 {
                                Text("Deal: ¥\(client.dealValue.formatted())")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            }
                            
                            if !client.notes.isEmpty {
                                Text(client.notes)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.dashed")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Text("Waiting for client detection...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var isConnected = false
    @Published var currentClient: ClientDisplayInfo?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if message["type"] as? String == "clientInfo" {
            let client = ClientDisplayInfo(
                name: message["name"] as? String ?? "",
                company: message["company"] as? String ?? "",
                position: message["position"] as? String ?? "",
                nextMeeting: message["nextMeeting"] as? String ?? "",
                notes: message["notes"] as? String ?? "",
                dealValue: message["dealValue"] as? Int ?? 0
            )
            
            DispatchQueue.main.async {
                self.currentClient = client
            }
        }
    }
}

struct ClientDisplayInfo {
    let name: String
    let company: String
    let position: String
    let nextMeeting: String
    let notes: String
    let dealValue: Int
}
