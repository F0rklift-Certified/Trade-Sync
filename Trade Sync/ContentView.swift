//
//  ContentView.swift
//  Trade Sync
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = JobViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            JobsListView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase.fill")
                }
                .tag(1)

            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(2)

            TradesmenView()
                .tabItem {
                    Label("Team", systemImage: "person.3.fill")
                }
                .tag(3)
        }
        .tint(AppTheme.orange)
        .environment(viewModel)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
