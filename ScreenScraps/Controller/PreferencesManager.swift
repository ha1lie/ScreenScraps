//
//  PreferencesManager.swift
//  ScreenScraps
//
//  Created by Hallie on 8/13/22.
//

import Foundation
import SwiftUI

class PreferencesManager: ObservableObject {
    public static let shared: PreferencesManager = PreferencesManager()
    
    public func doThing() {
        print("prefs manager doing thing!")
    }
}
