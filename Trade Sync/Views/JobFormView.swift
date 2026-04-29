import SwiftUI

// MARK: - Job Form View

struct JobFormView: View {
    @Environment(JobViewModel.self) var viewModel
    @Environment(\.dismiss) private var dismiss

    let editingJob: Job?

    @State private var customerName: String = ""
    @State private var address: String = ""
    @State private var jobType: JobType = .general
    @State private var scheduledDate: Date = Date()
    @State private var estimatedDuration: Double = 2
    @State private var assignedTradesmanId: UUID?
    @State private var priority: JobPriority = .medium
    @State private var notes: String = ""
    @State private var customerPhone: String = ""
    @State private var status: JobStatus = .scheduled

    init(editingJob: Job? = nil) {
        self.editingJob = editingJob
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.darkNavy.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Customer info
                        formSection("Customer Details") {
                            FormField(label: "Customer Name", text: $customerName, icon: "person.fill")
                            FormField(label: "Address", text: $address, icon: "mappin.circle.fill")
                            FormField(label: "Phone", text: $customerPhone, icon: "phone.fill")
                        }

                        // Job details
                        formSection("Job Details") {
                            // Job type picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Job Type")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textMuted)
                                Picker("Job Type", selection: $jobType) {
                                    ForEach(JobType.allCases) { type in
                                        Label(type.rawValue, systemImage: type.icon).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.orange)
                            }

                            // Priority picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Priority")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textMuted)
                                Picker("Priority", selection: $priority) {
                                    ForEach(JobPriority.allCases) { p in
                                        Text(p.rawValue).tag(p)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }

                            // Status picker (edit mode)
                            if editingJob != nil {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Status")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.textMuted)
                                    Picker("Status", selection: $status) {
                                        ForEach(JobStatus.allCases) { s in
                                            Text(s.rawValue).tag(s)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(AppTheme.orange)
                                }
                            }
                        }

                        // Scheduling
                        formSection("Schedule") {
                            DatePicker("Date & Time", selection: $scheduledDate)
                                .tint(AppTheme.orange)
                                .foregroundColor(AppTheme.textPrimary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Estimated Duration: \(Int(estimatedDuration))h")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textMuted)
                                Slider(value: $estimatedDuration, in: 0.5...12, step: 0.5)
                                    .tint(AppTheme.orange)
                            }

                            // Tradesman picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Assign Tradesman")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textMuted)
                                Picker("Tradesman", selection: $assignedTradesmanId) {
                                    Text("Unassigned").tag(nil as UUID?)
                                    ForEach(viewModel.tradesmen) { t in
                                        Text("\(t.name) — \(t.tradeType.rawValue)").tag(t.id as UUID?)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.orange)
                            }
                        }

                        // Notes
                        formSection("Notes") {
                            TextField("Additional notes...", text: $notes, axis: .vertical)
                                .lineLimit(3...6)
                                .foregroundColor(AppTheme.textPrimary)
                        }

                        // Save button
                        Button {
                            saveJob()
                        } label: {
                            Text(editingJob != nil ? "Update Job" : "Create Job")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(customerName.isEmpty || address.isEmpty ? AppTheme.textMuted : AppTheme.orange)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(customerName.isEmpty || address.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(editingJob != nil ? "Edit Job" : "New Job")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppTheme.orange)
                }
            }
            .onAppear { loadExistingJob() }
        }
    }

    // MARK: - Form Section Helper

    private func formSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            VStack(spacing: 14) {
                content()
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Actions

    private func loadExistingJob() {
        guard let job = editingJob else { return }
        customerName = job.customerName
        address = job.address
        jobType = job.jobType
        scheduledDate = job.scheduledDate
        estimatedDuration = job.estimatedDuration
        assignedTradesmanId = job.assignedTradesmanId
        priority = job.priority
        notes = job.notes
        customerPhone = job.customerPhone
        status = job.status
    }

    private func saveJob() {
        if let existing = editingJob {
            var updated = existing
            updated.customerName = customerName
            updated.address = address
            updated.jobType = jobType
            updated.scheduledDate = scheduledDate
            updated.estimatedDuration = estimatedDuration
            updated.assignedTradesmanId = assignedTradesmanId
            updated.priority = priority
            updated.notes = notes
            updated.customerPhone = customerPhone
            updated.status = status
            viewModel.updateJob(updated)
        } else {
            let newJob = Job(
                customerName: customerName,
                address: address,
                jobType: jobType,
                scheduledDate: scheduledDate,
                estimatedDuration: estimatedDuration,
                assignedTradesmanId: assignedTradesmanId,
                priority: priority,
                notes: notes,
                customerPhone: customerPhone
            )
            viewModel.addJob(newJob)
        }
        dismiss()
    }
}

// MARK: - Form Field

struct FormField: View {
    let label: String
    @Binding var text: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.textMuted)
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.orange)
                    .frame(width: 20)
                TextField(label, text: $text)
                    .foregroundColor(AppTheme.textPrimary)
            }
            Rectangle()
                .fill(AppTheme.textMuted.opacity(0.3))
                .frame(height: 1)
        }
    }
}

#Preview {
    JobFormView()
        .environment(JobViewModel())
}
