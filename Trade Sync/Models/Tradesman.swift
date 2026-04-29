import Foundation

// MARK: - Trade Type

enum TradeType: String, CaseIterable, Identifiable {
    case electrician = "Electrician"
    case plumber = "Plumber"
    case builder = "Builder"
    case painter = "Painter"
    case roofer = "Roofer"
    case hvacTech = "HVAC Technician"
    case landscaper = "Landscaper"
    case generalLabourer = "General Labourer"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .electrician: return "bolt.fill"
        case .plumber: return "drop.fill"
        case .builder: return "hammer.fill"
        case .painter: return "paintbrush.fill"
        case .roofer: return "house.fill"
        case .hvacTech: return "fan.fill"
        case .landscaper: return "leaf.fill"
        case .generalLabourer: return "wrench.fill"
        }
    }
}

// MARK: - Tradesman

struct Tradesman: Identifiable {
    let id: UUID
    var name: String
    var tradeType: TradeType
    var phone: String
    var email: String
    var isAvailable: Bool
    var avatarColor: String

    init(
        id: UUID = UUID(),
        name: String,
        tradeType: TradeType,
        phone: String = "",
        email: String = "",
        isAvailable: Bool = true,
        avatarColor: String = "blue"
    ) {
        self.id = id
        self.name = name
        self.tradeType = tradeType
        self.phone = phone
        self.email = email
        self.isAvailable = isAvailable
        self.avatarColor = avatarColor
    }
}
