//
//  SettingsView.swift
//  ScreenScraps
//
//  Created by Hallie on 8/13/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var prefManager: PreferencesManager = .shared
    
    var body: some View {
        VStack {
            Text("Settings")
            Button {
                self.prefManager.doThing()
            } label: {
                Text("Do setting")
            }
        }.frame(width: 600, height: 400)
    }
}
