import SwiftUI
import Observation

// MARK: - Job View Model

@Observable
class JobViewModel {
    var jobs: [Job]
    var tradesmen: [Tradesman]
    var searchText: String = ""
    var selectedStatusFilter: JobStatus?

    private let dataService = MockDataService.shared

    init() {
        self.jobs = dataService.generateJobs()
        self.tradesmen = dataService.generateTradesmen()
    }

    // MARK: - Computed Properties

    var todaysJobs: [Job] {
        let calendar = Calendar.current
        return jobs.filter { calendar.isDateInToday($0.scheduledDate) }
            .sorted { $0.scheduledDate < $1.scheduledDate }
    }

    var upcomingJobs: [Job] {
        let now = Calendar.current.startOfDay(for: Date())
        return jobs.filter { $0.scheduledDate >= now && $0.status != .completed && $0.status != .cancelled }
            .sorted { $0.scheduledDate < $1.scheduledDate }
    }

    var filteredJobs: [Job] {
        var result = jobs

        if let filter = selectedStatusFilter {
            result = result.filter { $0.status == filter }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.customerName.localizedCaseInsensitiveContains(searchText) ||
                $0.address.localizedCaseInsensitiveContains(searchText) ||
                $0.jobType.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result.sorted { $0.scheduledDate < $1.scheduledDate }
    }

    // MARK: - Dashboard Counts

    var scheduledCount: Int {
        todaysJobs.filter { $0.status == .scheduled }.count
    }

    var inProgressCount: Int {
        todaysJobs.filter { $0.status == .inProgress }.count
    }

    var completedCount: Int {
        todaysJobs.filter { $0.status == .completed }.count
    }

    // MARK: - Tradesman Helpers

    func tradesman(for id: UUID?) -> Tradesman? {
        guard let id else { return nil }
        return tradesmen.first { $0.id == id }
    }

    func jobs(for tradesmanId: UUID) -> [Job] {
        jobs.filter { $0.assignedTradesmanId == tradesmanId }
            .sorted { $0.scheduledDate < $1.scheduledDate }
    }

    func jobsForWeek(tradesmanId: UUID, weekStart: Date) -> [Job] {
        let calendar = Calendar.current
        guard let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { return [] }
        return jobs.filter {
            $0.assignedTradesmanId == tradesmanId &&
            $0.scheduledDate >= weekStart &&
            $0.scheduledDate < weekEnd
        }.sorted { $0.scheduledDate < $1.scheduledDate }
    }

    // MARK: - Actions

    func updateJobStatus(_ jobId: UUID, to status: JobStatus) {
        if let index = jobs.firstIndex(where: { $0.id == jobId }) {
            jobs[index].status = status
        }
    }

    func toggleChecklistItem(jobId: UUID, itemId: UUID) {
        if let jobIndex = jobs.firstIndex(where: { $0.id == jobId }),
           let itemIndex = jobs[jobIndex].checklist.firstIndex(where: { $0.id == itemId }) {
            jobs[jobIndex].checklist[itemIndex].isCompleted.toggle()
        }
    }

    func addJob(_ job: Job) {
        jobs.append(job)
    }

    func updateJob(_ job: Job) {
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index] = job
        }
    }

    func deleteJob(_ jobId: UUID) {
        jobs.removeAll { $0.id == jobId }
    }

    func addTradesman(_ tradesman: Tradesman) {
        tradesmen.append(tradesman)
    }
}
