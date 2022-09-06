//
//  ScreenScrapsApp.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import SwiftUI

@main
struct ScreenScrapsApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Image(systemName: "camera.metering.partial")
                .onAppear {
                    ScreenshotManager.shared.configure()
                }
        }.menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
