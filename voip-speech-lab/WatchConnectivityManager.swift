import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var isWatchConnected = false
    @Published var lastSentClient: String?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendClientInfo(_ clientInfo: ClientInfo) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let message: [String: Any] = [
            "type": "clientInfo",
            "name": clientInfo.name,
            "company": clientInfo.data.company,
            "position": clientInfo.data.position,
            "email": clientInfo.data.email,
            "phone": clientInfo.data.phone,
            "location": clientInfo.data.location,
            "nextMeeting": clientInfo.data.nextMeeting,
            "notes": clientInfo.data.notes,
            "dealValue": clientInfo.data.dealValue
        ]
        
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Failed to send message to watch: \(error)")
        }
        
        lastSentClient = clientInfo.name
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isWatchConnected = activationState == .activated && session.isReachable
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = session.isReachable
        }
    }
}
