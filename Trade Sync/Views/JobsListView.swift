import SwiftUI

// MARK: - Jobs List View

struct JobsListView: View {
    @Environment(JobViewModel.self) var viewModel
    @State private var showingNewJob = false

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.textMuted)
                    TextField("Search jobs...", text: $viewModel.searchText)
                        .foregroundColor(AppTheme.textPrimary)
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppTheme.textMuted)
                        }
                    }
                }
                .padding(12)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Status filter chips
                statusFilterChips

                // Job list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if viewModel.filteredJobs.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(AppTheme.textMuted)
                                Text("No jobs found")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textMuted)
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(viewModel.filteredJobs) { job in
                                NavigationLink(value: job.id) {
                                    JobCard(job: job, tradesman: viewModel.tradesman(for: job.assignedTradesmanId))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(AppTheme.darkNavy.ignoresSafeArea())
            .navigationTitle("Jobs")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewJob = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.orange)
                    }
                }
            }
            .sheet(isPresented: $showingNewJob) {
                JobFormView()
            }
            .navigationDestination(for: UUID.self) { jobId in
                if let job = viewModel.jobs.first(where: { $0.id == jobId }) {
                    JobDetailView(job: job)
                }
            }
        }
    }

    // MARK: - Status Filter Chips

    private var statusFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: viewModel.selectedStatusFilter == nil) {
                    viewModel.selectedStatusFilter = nil
                }
                ForEach(JobStatus.allCases) { status in
                    FilterChip(title: status.rawValue, isSelected: viewModel.selectedStatusFilter == status) {
                        viewModel.selectedStatusFilter = status
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption).bold()
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? AppTheme.orange : AppTheme.cardBackground)
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    JobsListView()
        .environment(JobViewModel())
}
