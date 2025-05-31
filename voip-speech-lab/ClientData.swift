import Foundation

struct ClientData: Codable {
    let company: String
    let position: String
    let email: String
    let phone: String
    let location: String
    let metAt: String
    let metDate: String
    let lastMeeting: String
    let lastConversation: String
    let nextMeeting: String
    let preferredContactTime: String
    let hobbies: [String]
    let birthday: String
    let notes: String
    let recentPurchase: String
    let salesStage: String
    let leadSource: String
    let dealValue: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case company, position, email, phone, location, hobbies, birthday, notes, language
        case metAt = "met_at"
        case metDate = "met_date"
        case lastMeeting = "last_meeting"
        case lastConversation = "last_conversation"
        case nextMeeting = "next_meeting"
        case preferredContactTime = "preferred_contact_time"
        case recentPurchase = "recent_purchase"
        case salesStage = "sales_stage"
        case leadSource = "lead_source"
        case dealValue = "deal_value"
    }
}

struct ClientInfo {
    let name: String
    let data: ClientData
}
