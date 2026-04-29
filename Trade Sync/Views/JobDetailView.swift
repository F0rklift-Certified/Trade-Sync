import SwiftUI
import PhotosUI

// MARK: - Job Detail View

struct JobDetailView: View {
    @Environment(JobViewModel.self) var viewModel
    let job: Job

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var showingStatusPicker = false

    private var currentJob: Job {
        viewModel.jobs.first { $0.id == job.id } ?? job
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Status header
                statusHeader

                // Job info card
                jobInfoCard

                // Assigned tradesman
                if let tradesman = viewModel.tradesman(for: currentJob.assignedTradesmanId) {
                    tradesmanCard(tradesman)
                }

                // Customer actions
                customerActionsCard

                // Checklist
                checklistCard

                // Notes
                if !currentJob.notes.isEmpty {
                    notesCard
                }

                // Photo section
                photoSection

                // Status update button
                statusUpdateButton
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(AppTheme.darkNavy.ignoresSafeArea())
        .navigationTitle(currentJob.jobType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .confirmationDialog("Update Status", isPresented: $showingStatusPicker) {
            ForEach(JobStatus.allCases) { status in
                Button(status.rawValue) {
                    viewModel.updateJobStatus(currentJob.id, to: status)
                }
            }
        }
    }

    // MARK: - Status Header

    private var statusHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                StatusBadge(status: currentJob.status)
                Text(currentJob.customerName)
                    .font(.title2).bold()
                    .foregroundColor(AppTheme.textPrimary)
            }
            Spacer()
            PriorityBadge(priority: currentJob.priority)
        }
        .padding(.top, 8)
    }

    // MARK: - Job Info Card

    private var jobInfoCard: some View {
        VStack(spacing: 14) {
            DetailRow(icon: "mappin.circle.fill", label: "Address", value: currentJob.address)
            Divider().overlay(AppTheme.textMuted.opacity(0.3))
            DetailRow(icon: job.jobType.icon, label: "Job Type", value: currentJob.jobType.rawValue)
            Divider().overlay(AppTheme.textMuted.opacity(0.3))
            DetailRow(icon: "calendar", label: "Date", value: currentJob.scheduledDate.formatted(date: .abbreviated, time: .omitted))
            Divider().overlay(AppTheme.textMuted.opacity(0.3))
            DetailRow(icon: "clock", label: "Time", value: currentJob.scheduledDate.formatted(date: .omitted, time: .shortened))
            Divider().overlay(AppTheme.textMuted.opacity(0.3))
            DetailRow(icon: "hourglass", label: "Duration", value: "\(Int(currentJob.estimatedDuration))h estimated")
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Tradesman Card

    private func tradesmanCard(_ tradesman: Tradesman) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(AppTheme.colorForAvatar(tradesman.avatarColor))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(tradesman.name.prefix(1))
                        .font(.title3).bold()
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(tradesman.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Text(tradesman.tradeType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            if let url = URL(string: "tel:\(tradesman.phone.replacingOccurrences(of: " ", with: ""))") {
                Link(destination: url) {
                    Image(systemName: "phone.circle.fill")
                        .font(.title)
                        .foregroundColor(AppTheme.statusCompleted)
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Customer Actions

    private var customerActionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Customer Contact")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)

            HStack(spacing: 12) {
                if let callURL = URL(string: "tel:\(currentJob.customerPhone.replacingOccurrences(of: " ", with: ""))") {
                    Link(destination: callURL) {
                        Label("Call", systemImage: "phone.fill")
                            .font(.subheadline).bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppTheme.statusCompleted.opacity(0.2))
                            .foregroundColor(AppTheme.statusCompleted)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }

                if let smsURL = URL(string: "sms:\(currentJob.customerPhone.replacingOccurrences(of: " ", with: ""))") {
                    Link(destination: smsURL) {
                        Label("Text", systemImage: "message.fill")
                            .font(.subheadline).bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppTheme.statusScheduled.opacity(0.2))
                            .foregroundColor(AppTheme.statusScheduled)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Checklist

    private var checklistCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Checklist")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                let completed = currentJob.checklist.filter(\.isCompleted).count
                Text("\(completed)/\(currentJob.checklist.count)")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }

            if currentJob.checklist.isEmpty {
                Text("No checklist items")
                    .foregroundColor(AppTheme.textMuted)
                    .padding(.vertical, 8)
            } else {
                ForEach(currentJob.checklist) { item in
                    Button {
                        viewModel.toggleChecklistItem(jobId: currentJob.id, itemId: item.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? AppTheme.statusCompleted : AppTheme.textMuted)
                                .font(.title3)

                            Text(item.title)
                                .foregroundColor(item.isCompleted ? AppTheme.textMuted : AppTheme.textPrimary)
                                .strikethrough(item.isCompleted)
                                .font(.subheadline)

                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Notes

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            Text(currentJob.notes)
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Photos

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Photos")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)

            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Add Photos")
                }
                .font(.subheadline).bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.orange.opacity(0.2))
                .foregroundColor(AppTheme.orange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            if !currentJob.photoFileNames.isEmpty {
                Text("\(currentJob.photoFileNames.count) photos attached")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Status Update Button

    private var statusUpdateButton: some View {
        Button {
            showingStatusPicker = true
        } label: {
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                Text("Update Status")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.orange)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.orange)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundColor(AppTheme.textMuted)
                .frame(width: 70, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(AppTheme.textPrimary)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        JobDetailView(job: MockDataService.shared.generateJobs()[0])
            .environment(JobViewModel())
    }
}
