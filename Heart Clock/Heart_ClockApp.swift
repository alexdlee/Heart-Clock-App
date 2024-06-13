//
//  Heart_ClockApp.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/13/24.
//

import SwiftUI

@main
struct Heart_ClockApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
