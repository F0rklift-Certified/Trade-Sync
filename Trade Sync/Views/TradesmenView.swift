import SwiftUI

// MARK: - Tradesmen View

struct TradesmenView: View {
    @Environment(JobViewModel.self) var viewModel
    @State private var showingAddTradesman = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(viewModel.tradesmen) { tradesman in
                        NavigationLink(value: tradesman.id) {
                            TradesmanCard(tradesman: tradesman, jobCount: viewModel.jobs(for: tradesman.id).count)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(AppTheme.darkNavy.ignoresSafeArea())
            .navigationTitle("Tradesmen")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTradesman = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddTradesman) {
                AddTradesmanView()
            }
            .navigationDestination(for: UUID.self) { tradesmanId in
                if let tradesman = viewModel.tradesmen.first(where: { $0.id == tradesmanId }) {
                    TradesmanDetailView(tradesman: tradesman)
                }
            }
        }
    }
}

// MARK: - Tradesman Card

struct TradesmanCard: View {
    let tradesman: Tradesman
    let jobCount: Int

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            Circle()
                .fill(AppTheme.colorForAvatar(tradesman.avatarColor))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(tradesman.name.prefix(1))
                        .font(.title3).bold()
                        .foregroundColor(.white)
                )

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(tradesman.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                HStack(spacing: 6) {
                    Image(systemName: tradesman.tradeType.icon)
                        .font(.caption)
                    Text(tradesman.tradeType.rawValue)
                        .font(.subheadline)
                }
                .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            // Status & job count
            VStack(alignment: .trailing, spacing: 4) {
                Text(tradesman.isAvailable ? "Available" : "Busy")
                    .font(.caption).bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(tradesman.isAvailable ? AppTheme.statusCompleted.opacity(0.2) : AppTheme.statusCancelled.opacity(0.2))
                    .foregroundColor(tradesman.isAvailable ? AppTheme.statusCompleted : AppTheme.statusCancelled)
                    .clipShape(Capsule())

                Text("\(jobCount) jobs")
                    .font(.caption)
                    .foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(14)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Tradesman Detail View

struct TradesmanDetailView: View {
    @Environment(JobViewModel.self) var viewModel
    let tradesman: Tradesman

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile header
                VStack(spacing: 12) {
                    Circle()
                        .fill(AppTheme.colorForAvatar(tradesman.avatarColor))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(tradesman.name.prefix(1))
                                .font(.largeTitle).bold()
                                .foregroundColor(.white)
                        )

                    Text(tradesman.name)
                        .font(.title2).bold()
                        .foregroundColor(AppTheme.textPrimary)

                    Text(tradesman.tradeType.rawValue)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.top, 8)

                // Contact info
                VStack(spacing: 14) {
                    DetailRow(icon: "phone.fill", label: "Phone", value: tradesman.phone)
                    Divider().overlay(AppTheme.textMuted.opacity(0.3))
                    DetailRow(icon: "envelope.fill", label: "Email", value: tradesman.email)
                    Divider().overlay(AppTheme.textMuted.opacity(0.3))
                    DetailRow(icon: "circle.fill", label: "Status", value: tradesman.isAvailable ? "Available" : "Busy")
                }
                .padding(16)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Assigned jobs
                VStack(alignment: .leading, spacing: 12) {
                    let tradesmanJobs = viewModel.jobs(for: tradesman.id)
                    HStack {
                        Text("Assigned Jobs")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                        Text("\(tradesmanJobs.count) total")
                            .font(.caption)
                            .foregroundColor(AppTheme.textMuted)
                    }

                    if tradesmanJobs.isEmpty {
                        Text("No jobs assigned")
                            .foregroundColor(AppTheme.textMuted)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(tradesmanJobs) { job in
                            NavigationLink {
                                JobDetailView(job: job)
                            } label: {
                                MiniJobCard(job: job)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(AppTheme.darkNavy.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Mini Job Card

struct MiniJobCard: View {
    let job: Job

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.colorForStatus(job.status))
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(job.customerName)
                    .font(.subheadline).bold()
                    .foregroundColor(AppTheme.textPrimary)
                Text(job.scheduledDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.leading, 6)

            Spacer()

            StatusBadge(status: job.status)
        }
        .padding(10)
        .background(AppTheme.cardBackgroundLight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Add Tradesman View

struct AddTradesmanView: View {
    @Environment(JobViewModel.self) var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var tradeType: TradeType = .electrician
    @State private var phone = ""
    @State private var email = ""

    private let avatarColors = ["orange", "blue", "green", "purple", "red"]

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.darkNavy.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 14) {
                            FormField(label: "Full Name", text: $name, icon: "person.fill")

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Trade")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textMuted)
                                Picker("Trade", selection: $tradeType) {
                                    ForEach(TradeType.allCases) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.orange)
                            }

                            FormField(label: "Phone", text: $phone, icon: "phone.fill")
                            FormField(label: "Email", text: $email, icon: "envelope.fill")
                        }
                        .padding(16)
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        Button {
                            let tradesman = Tradesman(
                                name: name,
                                tradeType: tradeType,
                                phone: phone,
                                email: email,
                                avatarColor: avatarColors.randomElement() ?? "blue"
                            )
                            viewModel.addTradesman(tradesman)
                            dismiss()
                        } label: {
                            Text("Add Tradesman")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(name.isEmpty ? AppTheme.textMuted : AppTheme.orange)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(name.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("New Tradesman")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppTheme.orange)
                }
            }
        }
    }
}

#Preview {
    TradesmenView()
        .environment(JobViewModel())
}
