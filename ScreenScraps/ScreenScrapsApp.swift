//
//  ScreenScrapsApp.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import SwiftUI

@main
struct ScreenScrapsApp: App {
    var body: some Scene {
        MenuBarExtra {
            VStack {
                ContentView()
            }
        } label: {
            Image(systemName: "camera.metering.partial")
                .onAppear {
                    ScreenshotManager.shared.configure()
                }
        }.menuBarExtraStyle(.window)
    }
}
