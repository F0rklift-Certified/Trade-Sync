import SwiftUI

// MARK: - Schedule View

struct ScheduleView: View {
    @Environment(JobViewModel.self) var viewModel
    @State private var selectedDate: Date = Date()

    private var weekDays: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Week navigation
                    weekNavigator

                    // Day selector
                    daySelector

                    // Tradesman schedule blocks
                    ForEach(viewModel.tradesmen) { tradesman in
                        tradesmanScheduleRow(tradesman)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(AppTheme.darkNavy.ignoresSafeArea())
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Week Navigator

    private var weekNavigator: some View {
        HStack {
            Button {
                withAnimation {
                    selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(AppTheme.orange)
            }

            Spacer()

            Text(weekRangeText)
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)

            Spacer()

            Button {
                withAnimation {
                    selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(AppTheme.orange)
            }
        }
        .padding(.vertical, 8)
    }

    private var weekRangeText: String {
        guard let first = weekDays.first, let last = weekDays.last else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return "\(formatter.string(from: first)) — \(formatter.string(from: last))"
    }

    // MARK: - Day Selector

    private var daySelector: some View {
        HStack(spacing: 6) {
            ForEach(weekDays, id: \.self) { day in
                let isSelected = Calendar.current.isDate(day, inSameDayAs: selectedDate)
                let isToday = Calendar.current.isDateInToday(day)

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedDate = day }
                } label: {
                    VStack(spacing: 4) {
                        Text(dayAbbreviation(day))
                            .font(.caption2)
                            .foregroundColor(isSelected ? .white : AppTheme.textMuted)
                        Text("\(Calendar.current.component(.day, from: day))")
                            .font(.subheadline).bold()
                            .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? AppTheme.orange : (isToday ? AppTheme.orange.opacity(0.2) : Color.clear))
                    )
                }
            }
        }
    }

    private func dayAbbreviation(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    // MARK: - Tradesman Schedule Row

    private func tradesmanScheduleRow(_ tradesman: Tradesman) -> some View {
        let dayJobs = viewModel.jobs.filter {
            $0.assignedTradesmanId == tradesman.id &&
            Calendar.current.isDate($0.scheduledDate, inSameDayAs: selectedDate)
        }.sorted { $0.scheduledDate < $1.scheduledDate }

        return VStack(alignment: .leading, spacing: 8) {
            // Tradesman header
            HStack(spacing: 10) {
                Circle()
                    .fill(AppTheme.colorForAvatar(tradesman.avatarColor))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(tradesman.name.prefix(1))
                            .font(.caption).bold()
                            .foregroundColor(.white)
                    )
                VStack(alignment: .leading) {
                    Text(tradesman.name)
                        .font(.subheadline).bold()
                        .foregroundColor(AppTheme.textPrimary)
                    Text(tradesman.tradeType.rawValue)
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Text("\(dayJobs.count) jobs")
                    .font(.caption)
                    .foregroundColor(AppTheme.textMuted)
            }

            // Job time blocks
            if dayJobs.isEmpty {
                Text("No jobs scheduled")
                    .font(.caption)
                    .foregroundColor(AppTheme.textMuted)
                    .padding(.vertical, 8)
                    .padding(.leading, 42)
            } else {
                ForEach(dayJobs) { job in
                    NavigationLink(value: job.id) {
                        ScheduleJobBlock(job: job)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .navigationDestination(for: UUID.self) { jobId in
            if let job = viewModel.jobs.first(where: { $0.id == jobId }) {
                JobDetailView(job: job)
            }
        }
    }
}

// MARK: - Schedule Job Block

struct ScheduleJobBlock: View {
    let job: Job

    var body: some View {
        HStack(spacing: 0) {
            // Color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.colorForStatus(job.status))
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(job.customerName)
                    .font(.subheadline).bold()
                    .foregroundColor(AppTheme.textPrimary)
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(job.scheduledDate.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "hourglass")
                            .font(.caption2)
                        Text("\(Int(job.estimatedDuration))h")
                            .font(.caption)
                    }
                }
                .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.leading, 10)

            Spacer()

            Image(systemName: job.jobType.icon)
                .foregroundColor(AppTheme.colorForStatus(job.status))
                .font(.subheadline)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(AppTheme.colorForStatus(job.status).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ScheduleView()
        .environment(JobViewModel())
}
