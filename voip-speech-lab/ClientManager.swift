import Foundation

class ClientManager: ObservableObject {
    @Published var clients: [String: ClientData] = [:]
    
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
            clients = try JSONDecoder().decode([String: ClientData].self, from: data)
        } catch {
            print("Failed to decode client data: \(error)")
        }
    }
    
    func findClient(by name: String) -> ClientInfo? {
        let normalizedSearchName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        for (clientName, clientData) in clients {
            let normalizedClientName = clientName.lowercased()
            
            if normalizedClientName.contains(normalizedSearchName) || 
               normalizedSearchName.contains(normalizedClientName) {
                return ClientInfo(name: clientName, data: clientData)
            }
            
            let nameParts = normalizedClientName.components(separatedBy: " ")
            for part in nameParts {
                if part.contains(normalizedSearchName) || normalizedSearchName.contains(part) {
                    return ClientInfo(name: clientName, data: clientData)
                }
            }
        }
        
        return nil
    }
}
