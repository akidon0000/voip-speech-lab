import Foundation

class ClientDataManager: ObservableObject {
    @Published var clients: [String: ClientInfo] = [:]
    
    init() {
        loadClients()
    }
    
    private func loadClients() {
        guard let url = Bundle.main.url(forResource: "test_clients", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load test_clients.json")
            return
        }
        
        do {
            let clientsDict = try JSONDecoder().decode([String: ClientInfo].self, from: data)
            DispatchQueue.main.async {
                self.clients = clientsDict
            }
        } catch {
            print("Failed to decode clients: \(error)")
        }
    }
    
    func findClient(from text: String) -> ClientInfo? {
        let lowercasedText = text.lowercased()
        
        for (name, client) in clients {
            let nameParts = name.lowercased().components(separatedBy: " ")
            
            for part in nameParts {
                if lowercasedText.contains(part) && part.count > 2 {
                    return client
                }
            }
            
            if lowercasedText.contains(name.lowercased()) {
                return client
            }
        }
        
        return nil
    }
}
