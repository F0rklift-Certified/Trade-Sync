import Foundation

// MARK: - Job Status

enum JobStatus: String, CaseIterable, Identifiable {
    case scheduled = "Scheduled"
    case inProgress = "In Progress"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case onHold = "On Hold"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .scheduled: return "calendar.badge.clock"
        case .inProgress: return "wrench.and.screwdriver"
        case .completed: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        case .onHold: return "pause.circle.fill"
        }
    }
}

// MARK: - Job Priority

enum JobPriority: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"

    var id: String { rawValue }

    var sortOrder: Int {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        case .urgent: return 3
        }
    }
}

// MARK: - Job Type

enum JobType: String, CaseIterable, Identifiable {
    case electrical = "Electrical"
    case plumbing = "Plumbing"
    case building = "Building"
    case painting = "Painting"
    case roofing = "Roofing"
    case hvac = "HVAC"
    case landscaping = "Landscaping"
    case general = "General"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .electrical: return "bolt.fill"
        case .plumbing: return "drop.fill"
        case .building: return "hammer.fill"
        case .painting: return "paintbrush.fill"
        case .roofing: return "house.fill"
        case .hvac: return "fan.fill"
        case .landscaping: return "leaf.fill"
        case .general: return "wrench.fill"
        }
    }
}

// MARK: - Checklist Item

struct ChecklistItem: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

// MARK: - Job

struct Job: Identifiable {
    let id: UUID
    var customerName: String
    var address: String
    var jobType: JobType
    var scheduledDate: Date
    var estimatedDuration: TimeInterval // in hours
    var assignedTradesmanId: UUID?
    var priority: JobPriority
    var notes: String
    var status: JobStatus
    var checklist: [ChecklistItem]
    var photoFileNames: [String]
    var customerPhone: String
    var createdDate: Date

    init(
        id: UUID = UUID(),
        customerName: String,
        address: String,
        jobType: JobType,
        scheduledDate: Date,
        estimatedDuration: TimeInterval = 2,
        assignedTradesmanId: UUID? = nil,
        priority: JobPriority = .medium,
        notes: String = "",
        status: JobStatus = .scheduled,
        checklist: [ChecklistItem] = [],
        photoFileNames: [String] = [],
        customerPhone: String = "",
        createdDate: Date = Date()
    ) {
        self.id = id
        self.customerName = customerName
        self.address = address
        self.jobType = jobType
        self.scheduledDate = scheduledDate
        self.estimatedDuration = estimatedDuration
        self.assignedTradesmanId = assignedTradesmanId
        self.priority = priority
        self.notes = notes
        self.status = status
        self.checklist = checklist
        self.photoFileNames = photoFileNames
        self.customerPhone = customerPhone
        self.createdDate = createdDate
    }
}
