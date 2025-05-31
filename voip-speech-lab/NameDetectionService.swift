import Foundation

class NameDetectionService: ObservableObject {
    private var clientManager: ClientManager
    @Published var detectedClient: ClientInfo?
    @Published var lastDetectionText = ""
    
    init(clientManager: ClientManager) {
        self.clientManager = clientManager
    }
    
    func analyzeText(_ text: String) {
        let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
        
        for clientName in clientManager.clients.keys {
            let nameParts = clientName.lowercased().components(separatedBy: " ")
            
            for namePart in nameParts {
                if namePart.count >= 3 {
                    for word in words {
                        if word.contains(namePart) || namePart.contains(word) {
                            if let client = clientManager.findClient(by: clientName) {
                                detectedClient = client
                                lastDetectionText = text
                                return
                            }
                        }
                    }
                }
            }
            
            let fullNameWords = nameParts.joined(separator: " ")
            if text.lowercased().contains(fullNameWords) {
                if let client = clientManager.findClient(by: clientName) {
                    detectedClient = client
                    lastDetectionText = text
                    return
                }
            }
        }
    }
    
    func clearDetection() {
        detectedClient = nil
        lastDetectionText = ""
    }
}
