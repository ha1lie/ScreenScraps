//
//  ScreenshotView.swift
//  ScreenScraps
//
//  Created by Hallie on 8/9/22.
//

import SwiftUI

struct ScreenshotView: View {
    
    let screenshot: Screenshot
    
    @State var renaming: Bool = false
    @FocusState var renamingFocus: Bool
    @State var rename: String = ""
    
    var body: some View {
        VStack {
            HStack {
                if let image = screenshot.image {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 75, maxHeight: 50)
                }
                
                VStack(alignment: .leading) {
                    if self.renaming {
                        TextField("Name", text: self.$rename)
                            .focused(self.$renamingFocus)
                            .onSubmit {
                                ScreenshotManager.shared.renameScreenshot(self.screenshot, to: self.rename)
                                self.rename = ""
                                self.renaming = false
                            }.onAppear {
                                self.renamingFocus = true
                            }
                    } else {
                        Text(screenshot.name ?? "Screenshot!")
                            .bold()
                    }
                    Text("1/12/32")
                }
                
                Spacer()
            }.padding()
        }.contextMenu {
            Button {
                self.renaming = true
            } label: {
                Text("Rename")
            }.keyboardShortcut("r")

            Button {
                print("Delete")
            } label: {
                Text("Delete")
            }
        }
    }
}
