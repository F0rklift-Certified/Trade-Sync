import SwiftUI

// MARK: - Dashboard View

struct DashboardView: View {
    @Environment(JobViewModel.self) var viewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header greeting
                    headerSection

                    // Summary cards
                    summaryCardsSection

                    // Today's jobs
                    todaysJobsSection

                    // Upcoming jobs
                    upcomingJobsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(AppTheme.darkNavy.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good \(greetingTime),")
                    .font(.title2)
                    .foregroundColor(AppTheme.textSecondary)
                Text("TradeSync HQ")
                    .font(.largeTitle).bold()
                    .foregroundColor(AppTheme.textPrimary)
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.orange)
        }
        .padding(.top, 8)
    }

    private var greetingTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "morning" }
        if hour < 17 { return "afternoon" }
        return "evening"
    }

    // MARK: - Summary Cards

    private var summaryCardsSection: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "Scheduled",
                count: viewModel.scheduledCount,
                icon: "calendar",
                color: AppTheme.statusScheduled
            )
            SummaryCard(
                title: "In Progress",
                count: viewModel.inProgressCount,
                icon: "wrench.and.screwdriver",
                color: AppTheme.statusInProgress
            )
            SummaryCard(
                title: "Completed",
                count: viewModel.completedCount,
                icon: "checkmark.circle",
                color: AppTheme.statusCompleted
            )
        }
    }

    // MARK: - Today's Jobs

    private var todaysJobsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Jobs")
                    .font(.title3).bold()
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("\(viewModel.todaysJobs.count) jobs")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }

            if viewModel.todaysJobs.isEmpty {
                emptyStateCard(message: "No jobs scheduled for today")
            } else {
                ForEach(viewModel.todaysJobs) { job in
                    NavigationLink(value: job.id) {
                        JobCard(job: job, tradesman: viewModel.tradesman(for: job.assignedTradesmanId))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationDestination(for: UUID.self) { jobId in
            if let job = viewModel.jobs.first(where: { $0.id == jobId }) {
                JobDetailView(job: job)
            }
        }
    }

    // MARK: - Upcoming Jobs

    private var upcomingJobsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming")
                    .font(.title3).bold()
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            let futureJobs = viewModel.upcomingJobs.filter {
                !Calendar.current.isDateInToday($0.scheduledDate)
            }

            if futureJobs.isEmpty {
                emptyStateCard(message: "No upcoming jobs")
            } else {
                ForEach(futureJobs.prefix(5)) { job in
                    NavigationLink(value: job.id) {
                        JobCard(job: job, tradesman: viewModel.tradesman(for: job.assignedTradesmanId))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func emptyStateCard(message: String) -> some View {
        HStack {
            Spacer()
            Text(message)
                .foregroundColor(AppTheme.textMuted)
                .padding(.vertical, 30)
            Spacer()
        }
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text("\(count)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)

            Text(title)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Job Card

struct JobCard: View {
    let job: Job
    let tradesman: Tradesman?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top row: status badge + time
            HStack {
                StatusBadge(status: job.status)
                Spacer()
                PriorityBadge(priority: job.priority)
            }

            // Customer & job type
            HStack(spacing: 8) {
                Image(systemName: job.jobType.icon)
                    .foregroundColor(AppTheme.orange)
                    .font(.subheadline)
                Text(job.customerName)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
            }

            // Address
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(AppTheme.textMuted)
                    .font(.caption)
                Text(job.address)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .lineLimit(1)
            }

            // Bottom row: tradesman + time
            HStack {
                if let tradesman {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(AppTheme.colorForAvatar(tradesman.avatarColor))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Text(tradesman.name.prefix(1))
                                    .font(.caption2).bold()
                                    .foregroundColor(.white)
                            )
                        Text(tradesman.name)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(job.scheduledDate.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                }
                .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(14)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Status Badge

struct StatusBadge: View {
    let status: JobStatus

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.caption2)
            Text(status.rawValue)
                .font(.caption).bold()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(AppTheme.colorForStatus(status).opacity(0.2))
        .foregroundColor(AppTheme.colorForStatus(status))
        .clipShape(Capsule())
    }
}

// MARK: - Priority Badge

struct PriorityBadge: View {
    let priority: JobPriority

    var body: some View {
        Text(priority.rawValue)
            .font(.caption2).bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(AppTheme.colorForPriority(priority).opacity(0.2))
            .foregroundColor(AppTheme.colorForPriority(priority))
            .clipShape(Capsule())
    }
}

#Preview {
    DashboardView()
        .environment(JobViewModel())
}
