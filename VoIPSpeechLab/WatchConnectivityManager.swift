import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var isConnected = false
    @Published var lastSentClient: ClientInfo?
    
    override init() {
        super.init()
        setupWatchConnectivity()
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendClientInfo(_ client: ClientInfo) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let clientData = try encoder.encode(client)
            let message = ["clientInfo": clientData]
            
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Failed to send client info: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.lastSentClient = client
            }
        } catch {
            print("Failed to encode client info: \(error)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}
