//
//  Screenshot.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import Foundation
import AppKit

struct Screenshot: Hashable {
    var location: URL? {
        didSet {
            if let location = self.location {
                let attrs = try? FileManager.default.attributesOfItem(atPath: location.path) as NSDictionary
                if let attrs = attrs {
                    self.creationDate = attrs.fileCreationDate()
                }
            }
        }
    }
    var name: String?
    var image: NSImage?
    var creationDate: Date?
}
