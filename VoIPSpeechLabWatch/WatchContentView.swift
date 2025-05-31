import SwiftUI

struct WatchContentView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                    Text("VoIP Lab")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                if let client = watchConnectivity.currentClient {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(client.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(client.company)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(client.position)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Label(client.phone, systemImage: "phone")
                                .font(.caption2)
                            Label(client.location, systemImage: "location")
                                .font(.caption2)
                        }
                        
                        if !client.notes.isEmpty {
                            Text(client.notes)
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .padding(.top, 4)
                        }
                        
                        if !client.nextMeeting.isEmpty {
                            Text("Next: \(client.nextMeeting)")
                                .font(.caption2)
                                .foregroundColor(.orange)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.dashed")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("Waiting for client info...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                
                HStack {
                    Circle()
                        .fill(watchConnectivity.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(watchConnectivity.isConnected ? "Connected" : "Disconnected")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchContentView()
    }
}
