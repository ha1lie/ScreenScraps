//
//  ScreenshotManager.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import Foundation
import AppKit

class ScreenshotManager: ObservableObject {
    public static let shared: ScreenshotManager = ScreenshotManager()
    
    @Published var screenshots: [Screenshot] = []
    
    private var screenshotDefaults = UserDefaults(suiteName: "com.apple.screencapture")
    
    private var screenshotFolderURL: URL? = nil
    
    func configure() {
        self.screenshotFolderURL = URL(fileURLWithPath: self.readScreenshotLocationPath())
        
        self.screenshots = self.getScreenshots()
        
        self.beginMonitoring()
    }
    
    public func setStorage(to loc: String = "~/Screenshots") {
        // Check if there is a folder there
        print("[-] UNFINISHED. Set storage location to place!")
        // Make one if not
        
        // Run defaults set command
        // defaults write com.apple.screencapture location -string "~/Screenshots"
        
        let process = Process()
        process.standardInput = nil
        process.standardError = nil
        process.standardOutput = nil
    }
    
    /// Reads Screen Capture.app's location default
    /// - Returns: String representation of expanded path
    public func readScreenshotLocationPath() -> String {
        let loc = screenshotDefaults?.string(forKey: "location") ?? ""
        
        if loc.prefix(1) == "~" {
            let begin = FileManager.default.homeDirectoryForCurrentUser.path
            return begin + loc.suffix(loc.count - 1)
        }
        
        return loc
    }
    
    //MARK: Folder manipulation
    
    public func renameScreenshot(_ screenshot: Screenshot, to name: String) {
        guard self.screenshots.contains(where: { $0 == screenshot }) else { return }
        guard let folderURL = self.screenshotFolderURL else { return }
        
        var renamed = screenshot
        renamed.name = name
        
        guard let _ = renamed.location else { return }
        
        var success: Bool = true
        
        let newLoc = URL(fileURLWithPath: "\(name).png", relativeTo: folderURL)
        
        do {
            try FileManager.default.moveItem(at: renamed.location!, to: newLoc)
        } catch {
            success = false
            print("Failed to move the screenshot!")
        }
        
        if success {
            // Change everything!
            renamed.location = newLoc
            self.screenshots.removeAll(where: { $0 == screenshot })
            self.screenshots.append(renamed)
        }
    }
    
    /// Delete a screenshot from the folder, also removes from list
    /// - Parameter screenshot: Screenshot to delete
    public func deleteScreenshot(_ screenshot: Screenshot) {
        print("[-] UNFINISHED. Delete screenshot")
    }
    
    /// Copy a screenshot image to your clipboard
    /// - Parameter screenshot: Screenshot to copy
    public func copyScreenshot(_ screenshot: Screenshot) {
        print("[-] UNFINISHED. Copy to clipboard")
    }
    
    /// Opens a screenshot in Preview.app
    /// - Parameter screenshot: Screenshot to open
    public func openScreenshot(_ screenshot: Screenshot) {
        print("[-] UNFINISHED. Open in preview")
    }
    
    //MARK: Folder observation
    
    private var folderMonitorQueue: DispatchQueue = DispatchQueue(label: "ScreenshotFolderMonitorQueue", attributes: [.concurrent])
    private var folderMonitorSource: DispatchSourceFileSystemObject?
    private var folderFileDescriptor: CInt = -1
    
    /// Begins to watch for new screenshots in the folder :)
    public func beginMonitoring() {
        guard let _ = self.screenshotFolderURL else { return }
        guard folderMonitorSource == nil && folderFileDescriptor == -1 else { return }

        folderFileDescriptor = open(self.screenshotFolderURL!.path, O_EVTONLY)
        
        folderMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: folderFileDescriptor, eventMask: .write, queue: folderMonitorQueue)
        
        folderMonitorSource?.setEventHandler(handler: {
            self.folderUpdateHandler()
        })
        
        folderMonitorSource?.setCancelHandler(handler: {
            close(self.folderFileDescriptor)
            self.folderFileDescriptor = -1
            self.folderMonitorSource = nil
        })
        
        folderMonitorSource?.resume()
    }
    
    public func endMonitoring() {
        self.folderMonitorSource?.cancel()
        self.folderMonitorSource = nil
    }
    
    public func getScreenshots() -> [Screenshot] {
        guard let path = self.screenshotFolderURL?.path else { return [] }
        
        var contents: [String] = []
        
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print("[-] Failed to read the contents of the screenshot directory")
        }
        
        var newScreenshots: [Screenshot] = []
        
        for path in contents {
            if path.suffix(4) == ".png" {
                // Should be a screenshot
                var screenshot = Screenshot(name: String(path.prefix(path.count - 4)))
                screenshot.location = URL(fileURLWithPath: path, relativeTo: self.screenshotFolderURL)
                
                if let location = screenshot.location {
                    let image = NSImage(contentsOf: location)
                    screenshot.image = image
                }
                
                newScreenshots.append(screenshot)
            }
        }
        
        return newScreenshots
    }
    
    /// Runs when there is a change to the items within the screenshot folder
    public func folderUpdateHandler() {
        guard let path = self.screenshotFolderURL?.path else { return }
        
        var contents: [String] = []
        
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print("Failed to read contents of screenshot directory")
        }
        
        if contents.count > self.screenshots.count {
            // There's more screenshots... one was added!
            for path in contents {
                if path.suffix(4) == ".png" && !self.screenshots.contains(where: { $0.name == String(path.prefix(path.count - 4))}) {
                    var screenshot = Screenshot(name: String(path.prefix(path.count - 4)))
                    screenshot.location = URL(fileURLWithPath: path, relativeTo: self.screenshotFolderURL)
                    
                    if let location = screenshot.location {
                        let image = NSImage(contentsOf: location)
                        screenshot.image = image
                    }
                    
                    DispatchQueue.main.async {
                        self.screenshots.append(screenshot)
                    }
                }
            }
        }
    }
}
