import Foundation

// MARK: - Mock Data Service

class MockDataService {
    static let shared = MockDataService()

    // Fixed UUIDs for tradesmen so jobs can reference them
    let tradesmanIds: [UUID] = [
        UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567801")!,
        UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567802")!,
        UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567803")!,
        UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567804")!,
        UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567805")!,
    ]

    func generateTradesmen() -> [Tradesman] {
        [
            Tradesman(
                id: tradesmanIds[0],
                name: "Mike Thompson",
                tradeType: .electrician,
                phone: "0412 345 678",
                email: "mike@tradesync.com",
                isAvailable: true,
                avatarColor: "orange"
            ),
            Tradesman(
                id: tradesmanIds[1],
                name: "Dave Wilson",
                tradeType: .plumber,
                phone: "0423 456 789",
                email: "dave@tradesync.com",
                isAvailable: true,
                avatarColor: "blue"
            ),
            Tradesman(
                id: tradesmanIds[2],
                name: "Sam Carter",
                tradeType: .builder,
                phone: "0434 567 890",
                email: "sam@tradesync.com",
                isAvailable: false,
                avatarColor: "green"
            ),
            Tradesman(
                id: tradesmanIds[3],
                name: "James O'Brien",
                tradeType: .painter,
                phone: "0445 678 901",
                email: "james@tradesync.com",
                isAvailable: true,
                avatarColor: "purple"
            ),
            Tradesman(
                id: tradesmanIds[4],
                name: "Tom Richards",
                tradeType: .roofer,
                phone: "0456 789 012",
                email: "tom@tradesync.com",
                isAvailable: true,
                avatarColor: "red"
            ),
        ]
    }

    func generateJobs() -> [Job] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return [
            // Today's jobs
            Job(
                customerName: "Sarah Mitchell",
                address: "14 Banksia Drive, Epping VIC 3076",
                jobType: .electrical,
                scheduledDate: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today)!,
                estimatedDuration: 3,
                assignedTradesmanId: tradesmanIds[0],
                priority: .high,
                notes: "Full rewire of kitchen and laundry. Customer has small dog — keep gate closed.",
                status: .inProgress,
                checklist: [
                    ChecklistItem(title: "Isolate power to kitchen circuit", isCompleted: true),
                    ChecklistItem(title: "Remove old wiring", isCompleted: true),
                    ChecklistItem(title: "Run new cables", isCompleted: false),
                    ChecklistItem(title: "Install new outlets", isCompleted: false),
                    ChecklistItem(title: "Test and certify", isCompleted: false),
                ],
                customerPhone: "0401 234 567"
            ),
            Job(
                customerName: "Brian Cooper",
                address: "7 Elm Street, Brunswick VIC 3056",
                jobType: .plumbing,
                scheduledDate: calendar.date(bySettingHour: 9, minute: 30, second: 0, of: today)!,
                estimatedDuration: 2,
                assignedTradesmanId: tradesmanIds[1],
                priority: .urgent,
                notes: "Burst pipe in bathroom — water turned off at mains. Urgent fix needed.",
                status: .scheduled,
                checklist: [
                    ChecklistItem(title: "Assess pipe damage"),
                    ChecklistItem(title: "Replace burst section"),
                    ChecklistItem(title: "Pressure test"),
                    ChecklistItem(title: "Restore water supply"),
                ],
                customerPhone: "0402 345 678"
            ),
            Job(
                customerName: "Linda Park",
                address: "22 Sunset Boulevard, Richmond VIC 3121",
                jobType: .painting,
                scheduledDate: calendar.date(bySettingHour: 7, minute: 0, second: 0, of: today)!,
                estimatedDuration: 6,
                assignedTradesmanId: tradesmanIds[3],
                priority: .medium,
                notes: "Interior repaint — 3 bedrooms and hallway. Colour: Dulux Whisper White.",
                status: .completed,
                checklist: [
                    ChecklistItem(title: "Prep walls and mask edges", isCompleted: true),
                    ChecklistItem(title: "Apply primer coat", isCompleted: true),
                    ChecklistItem(title: "First top coat", isCompleted: true),
                    ChecklistItem(title: "Second top coat", isCompleted: true),
                    ChecklistItem(title: "Touch-ups and cleanup", isCompleted: true),
                ],
                customerPhone: "0403 456 789"
            ),
            Job(
                customerName: "Greg Novak",
                address: "5 Industrial Way, Dandenong VIC 3175",
                jobType: .hvac,
                scheduledDate: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: today)!,
                estimatedDuration: 4,
                assignedTradesmanId: tradesmanIds[0],
                priority: .medium,
                notes: "Install split system AC in warehouse office. Unit already on-site.",
                status: .scheduled,
                checklist: [
                    ChecklistItem(title: "Mount indoor unit"),
                    ChecklistItem(title: "Mount outdoor unit"),
                    ChecklistItem(title: "Run refrigerant lines"),
                    ChecklistItem(title: "Electrical connection"),
                    ChecklistItem(title: "Commission and test"),
                ],
                customerPhone: "0404 567 890"
            ),

            // Tomorrow's jobs
            Job(
                customerName: "Emily Watson",
                address: "31 Collins Street, Melbourne VIC 3000",
                jobType: .building,
                scheduledDate: calendar.date(byAdding: .day, value: 1, to: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today)!)!,
                estimatedDuration: 8,
                assignedTradesmanId: tradesmanIds[2],
                priority: .high,
                notes: "Deck extension — 4m x 6m merbau. Council permit approved.",
                status: .scheduled,
                checklist: [
                    ChecklistItem(title: "Set out and level bearers"),
                    ChecklistItem(title: "Install joists"),
                    ChecklistItem(title: "Lay decking boards"),
                    ChecklistItem(title: "Install fascia"),
                    ChecklistItem(title: "Apply oil finish"),
                ],
                customerPhone: "0405 678 901"
            ),
            Job(
                customerName: "Richard Tran",
                address: "88 High Street, Preston VIC 3072",
                jobType: .roofing,
                scheduledDate: calendar.date(byAdding: .day, value: 1, to: calendar.date(bySettingHour: 7, minute: 30, second: 0, of: today)!)!,
                estimatedDuration: 5,
                assignedTradesmanId: tradesmanIds[4],
                priority: .high,
                notes: "Replace damaged roof tiles after storm. Approx 40 tiles needed.",
                status: .scheduled,
                checklist: [
                    ChecklistItem(title: "Safety setup — harness and edge protection"),
                    ChecklistItem(title: "Remove broken tiles"),
                    ChecklistItem(title: "Check battens and sarking"),
                    ChecklistItem(title: "Install new tiles"),
                    ChecklistItem(title: "Clean gutters"),
                ],
                customerPhone: "0406 789 012"
            ),

            // Later this week
            Job(
                customerName: "Anita Desai",
                address: "9 Park Lane, Kew VIC 3101",
                jobType: .electrical,
                scheduledDate: calendar.date(byAdding: .day, value: 3, to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!)!,
                estimatedDuration: 2,
                assignedTradesmanId: tradesmanIds[0],
                priority: .low,
                notes: "Install downlights in living room — 6 LED fittings.",
                status: .scheduled,
                checklist: [
                    ChecklistItem(title: "Mark out positions"),
                    ChecklistItem(title: "Cut ceiling holes"),
                    ChecklistItem(title: "Run cables"),
                    ChecklistItem(title: "Install fittings"),
                    ChecklistItem(title: "Test all lights"),
                ],
                customerPhone: "0407 890 123"
            ),
            Job(
                customerName: "Mark Sullivan",
                address: "63 Beach Road, Sandringham VIC 3191",
                jobType: .plumbing,
                scheduledDate: calendar.date(byAdding: .day, value: 4, to: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!)!,
                estimatedDuration: 3,
                assignedTradesmanId: tradesmanIds[1],
                priority: .medium,
                notes: "Bathroom renovation plumbing — relocate shower and vanity waste.",
                status: .scheduled,
                checklist: [
                    ChecklistItem(title: "Demo existing plumbing"),
                    ChecklistItem(title: "Rough-in new positions"),
                    ChecklistItem(title: "Install new fixtures"),
                    ChecklistItem(title: "Pressure test"),
                ],
                customerPhone: "0408 901 234"
            ),
            Job(
                customerName: "Jenny Li",
                address: "12 Acacia Avenue, Camberwell VIC 3124",
                jobType: .landscaping,
                scheduledDate: calendar.date(byAdding: .day, value: 5, to: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today)!)!,
                estimatedDuration: 6,
                assignedTradesmanId: tradesmanIds[2],
                priority: .low,
                notes: "Front garden redesign — remove old lawn, install native garden bed.",
                status: .onHold,
                checklist: [
                    ChecklistItem(title: "Remove existing lawn"),
                    ChecklistItem(title: "Prepare garden beds"),
                    ChecklistItem(title: "Install irrigation"),
                    ChecklistItem(title: "Plant natives"),
                    ChecklistItem(title: "Lay mulch"),
                ],
                customerPhone: "0409 012 345"
            ),
        ]
    }
}
