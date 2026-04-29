import SwiftUI

// MARK: - App Theme

struct AppTheme {
    // Primary colors
    static let navy = Color(red: 0.08, green: 0.11, blue: 0.20)
    static let darkNavy = Color(red: 0.05, green: 0.07, blue: 0.14)
    static let orange = Color(red: 1.0, green: 0.55, blue: 0.0)
    static let lightOrange = Color(red: 1.0, green: 0.70, blue: 0.30)

    // Surface colors
    static let cardBackground = Color(red: 0.12, green: 0.15, blue: 0.25)
    static let cardBackgroundLight = Color(red: 0.16, green: 0.19, blue: 0.30)
    static let surfaceDark = Color(red: 0.06, green: 0.08, blue: 0.16)

    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let textMuted = Color(white: 0.45)

    // Status colors
    static let statusScheduled = Color(red: 0.30, green: 0.60, blue: 1.0)
    static let statusInProgress = AppTheme.orange
    static let statusCompleted = Color(red: 0.20, green: 0.80, blue: 0.40)
    static let statusCancelled = Color(red: 0.90, green: 0.30, blue: 0.30)
    static let statusOnHold = Color(red: 0.70, green: 0.70, blue: 0.70)

    // Priority colors
    static let priorityLow = Color(red: 0.40, green: 0.75, blue: 0.40)
    static let priorityMedium = Color(red: 0.30, green: 0.60, blue: 1.0)
    static let priorityHigh = AppTheme.orange
    static let priorityUrgent = Color(red: 1.0, green: 0.30, blue: 0.30)

    static func colorForStatus(_ status: JobStatus) -> Color {
        switch status {
        case .scheduled: return statusScheduled
        case .inProgress: return statusInProgress
        case .completed: return statusCompleted
        case .cancelled: return statusCancelled
        case .onHold: return statusOnHold
        }
    }

    static func colorForPriority(_ priority: JobPriority) -> Color {
        switch priority {
        case .low: return priorityLow
        case .medium: return priorityMedium
        case .high: return priorityHigh
        case .urgent: return priorityUrgent
        }
    }

    static func colorForAvatar(_ name: String) -> Color {
        switch name {
        case "orange": return .orange
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "red": return .red
        default: return .gray
        }
    }
}
