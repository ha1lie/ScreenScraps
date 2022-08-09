//
//  Screenshot.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import Foundation
import AppKit

struct Screenshot: Hashable {
    var location: URL?
    var name: String?
    var image: NSImage?
}
