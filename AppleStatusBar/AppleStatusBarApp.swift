//
//  AppleStatusBarApp.swift
//  AppleStatusBar
//
//  Created by Sean Hong on 1/8/24.
//

import SwiftUI


@main
struct AppleStatusBarApp: App {
    @StateObject private var viewModel: AppleStatusBarViewModel = AppleStatusBarViewModel()
    
    static let subsystem = "AppleStatusBarApp"
    
    var body: some Scene {
        MenuBarExtra("App Menu Bar Extra", systemImage: "heart.fill") {
            ContentView()
                .environmentObject(viewModel)
        }
        .menuBarExtraStyle(.window)
    }
    
}
