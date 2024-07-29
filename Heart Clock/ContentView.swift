//
//  ContentView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/13/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = AlarmViewModel()
    @StateObject private var savedAlarms = SavedAlarms()
    @StateObject private var savedSessions = SavedStudySessions()
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        TabView {
            HomeView()
            
        }
        .environmentObject(viewModel)
        .environmentObject(savedAlarms)
        .environmentObject(savedSessions)
        .environmentObject(manager)

    }
                            
}

#Preview {
    ContentView()
}
