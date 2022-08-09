//
//  ContentView.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var screenshotManager: ScreenshotManager = .shared
    @State var selected: Screenshot? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("Screenshots")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button {
                    print("Show settings")
                } label: {
                    Image(systemName: "gear")
                }.buttonStyle(.plain)
            }.padding()
            
            List(selection: self.$selected) {
                ForEach(self.screenshotManager.screenshots, id: \.self) { screenshot in
                    ScreenshotView(screenshot: screenshot)
                }
            }
        }
    }
}
