# TradeSync

A job scheduling and dispatch app for trade businesses — electricians, plumbers, builders, and more. Built with Swift and SwiftUI.

## Overview

TradeSync helps trade businesses manage their day-to-day operations with two user roles:

- **Admin / Office Staff** — Create jobs, assign tradesmen, and manage the schedule
- **Tradesman** — View assigned jobs, update job status, and upload site photos

## Features

### Dashboard
- Summary cards showing today's scheduled, in-progress, and completed job counts
- Scrollable list of today's jobs and upcoming jobs with status badges

### Job Management
- Create, edit, and view jobs with full details: customer name, address, job type, date/time, assigned tradesman, priority, notes, and status
- Search and filter jobs by status
- Priority levels: Low, Medium, High, Urgent

### Schedule View
- Weekly calendar with day-by-day navigation
- Per-tradesman schedule rows with colour-coded time blocks
- Quick access to job details from schedule entries

### Tradesman Management
- Add and view tradesman profiles with name, trade type, phone, and email
- View all jobs assigned to each tradesman
- Availability status indicators

### Job Detail View
- Full job information with task checklist (interactive toggle)
- Status update workflow
- Photo picker for on-site documentation
- One-tap customer call and text buttons

## Tech Stack

- **UI**: SwiftUI
- **Architecture**: MVVM with `@Observable` (Swift Observation framework)
- **Navigation**: `NavigationStack`
- **Data**: Local mock data service (Core Data ready structure)
- **Min Target**: iOS 17+

## Project Structure

```
Trade Sync/
├── Models/
│   ├── Job.swift              # Job, JobStatus, JobPriority, JobType, ChecklistItem
│   └── Tradesman.swift        # Tradesman, TradeType
├── ViewModels/
│   └── JobViewModel.swift     # Central observable view model
├── Views/
│   ├── DashboardView.swift    # Home dashboard with summary cards
│   ├── JobsListView.swift     # Searchable/filterable job list
│   ├── JobDetailView.swift    # Full job detail with checklist & actions
│   ├── JobFormView.swift      # Create/edit job form
│   ├── ScheduleView.swift     # Weekly calendar schedule
│   └── TradesmenView.swift    # Team list, profiles, add tradesman
├── Services/
│   └── MockDataService.swift  # Sample data generation
├── Theme/
│   └── AppTheme.swift         # Dark navy + orange colour system
├── ContentView.swift          # Tab bar root navigation
└── Trade_SyncApp.swift        # App entry point
```

## Design

- Dark navy background with orange accents
- High contrast for outdoor readability on-site
- Mobile-first, clean and bold UI
- Colour-coded status and priority badges throughout

## Getting Started

1. Open `Trade Sync.xcodeproj` in Xcode 15+
2. Select an iOS 17+ simulator or device
3. Build and run

The app launches with pre-populated mock data so you can explore all features immediately.
