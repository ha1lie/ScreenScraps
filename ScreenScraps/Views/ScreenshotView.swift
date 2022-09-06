//
//  ScreenshotView.swift
//  ScreenScraps
//
//  Created by Hallie on 8/9/22.
//

import SwiftUI

struct ScreenshotView: View {
    
    let screenshot: Screenshot
    
    var formatter: DateFormatter {
        let format = DateFormatter()
        // Feel free to change the below, this is how I like it
        //TODO: Make this a preference!
        format.dateFormat = "h:mm a - M/d/YY"
        return format
    }
    
    var body: some View {
        VStack {
            HStack {
                if let image = screenshot.image {
                    Image(nsImage: image)
                        .resizable()
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(.primary, lineWidth: 1)
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 75, maxHeight: 50)
                }

                VStack(alignment: .leading) {
                    Text(screenshot.name ?? "Screenshot!")
                        .bold()

                    if let date = self.screenshot.creationDate {
                        Text(self.formatter.string(from: date))
                    }

                    Spacer()
                }
                Spacer()
            }
        }.onDrag {
            if let _ = self.screenshot.location {
                if let provider = NSItemProvider(contentsOf: self.screenshot.location!) {
                    return provider
                }
            }
            return NSItemProvider(contentsOf: URL(string: ""))!
        }
    }
}
