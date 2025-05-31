import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var isConnected = false
    @Published var currentClient: ClientInfo?
    
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
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = activationState == .activated
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let clientData = message["clientInfo"] as? Data {
            do {
                let decoder = JSONDecoder()
                let client = try decoder.decode(ClientInfo.self, from: clientData)
                DispatchQueue.main.async {
                    self.currentClient = client
                }
            } catch {
                print("Failed to decode client info: \(error)")
            }
        }
    }
}
