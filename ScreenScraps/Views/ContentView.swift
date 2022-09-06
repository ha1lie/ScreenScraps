//
//  ContentView.swift
//  ScreenScraps
//
//  Created by Hallie on 8/8/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var screenshotManager: ScreenshotManager = .shared
    @State var selected: Screenshot? = nil
    
    @State var renaming: Bool = false {
        didSet {
            self.renameFieldFocus = renaming
        }
    }
    @FocusState var renameFieldFocus: Bool
    @State var newName: String = ""
    @State var validRename: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack { //MARK: View
                HStack {
                    Text("Screenshots")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                }.padding([.top, .horizontal])
                
                List(selection: self.$selected) {
                    ForEach(self.screenshotManager.screenshots.sorted(by: {
                        if let cr1 = $0.creationDate, let cr2 = $1.creationDate {
                            return cr1 > cr2
                        }
                        return true
                    }), id: \.self) { screenshot in
                        ScreenshotView(screenshot: screenshot)
                            .padding(.vertical, 2)
                            .onTapGesture(count: 2) {
                                screenshotManager.openScreenshot(screenshot)
                            }.contextMenu {
                                Button {
                                    screenshotManager.copyScreenshot(screenshot)
                                } label: {
                                    HStack {
                                        Image(systemName: "doc.on.doc.fill")
                                        Text("Copy Image")
                                    }
                                }
                                
                                Button {
                                    self.selected = screenshot
                                    self.renaming = true
                                } label: {
                                    HStack {
                                        Image(systemName: "character.cursor.ibeam")
                                        Text("Rename")
                                    }.foregroundColor(.red)
                                }.buttonStyle(PlainButtonStyle())
                                
                                Divider()
                                
                                Button {
                                    screenshotManager.deleteScreenshot(screenshot)
                                } label: {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    }.foregroundColor(.red)
                                }.buttonStyle(PlainButtonStyle())
                            }
                    }.onDelete(perform: delete(at:))
                }
            }
            
            if self.renaming {
                VStack { //MARK: Rename popup!
                    VStack(alignment: .leading) {
                        Text("Rename screenshot")
                            .font(.title2)
                            .bold()
                        
                        HStack(spacing: 8) {
                            Group {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.textBackground)
                                    
                                    TextField("New Name", text: self.$newName)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .focused(self.$renameFieldFocus)
                                        .onSubmit {
                                            self.attemptRename()
                                        }.padding(8)
                                }
                                
                                Button {
                                    self.attemptRename()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundColor(.button)
                                            .frame(width: 80)
                                        Text("Change")
                                            .bold()
                                    }
                                }.buttonStyle(PlainButtonStyle())
                            }.frame(height: 40)
                        }
                    }.padding()
                        .padding(.top, 20)
                }.background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .padding(.top, -20)
                    .transition(.move(edge: .top))
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for offset in offsets {
            let deletable = self.screenshotManager.screenshots.sorted(by: {
                if let cr1 = $0.creationDate, let cr2 = $1.creationDate {
                    return cr1 > cr2
                }
                return true
            })[offset]
            
            screenshotManager.deleteScreenshot(deletable)
        }
    }
    
    private func attemptRename() {
        guard let _ = self.selected else { print("Can't rename nothing"); return }
        withAnimation {
            if screenshotManager.canRenameTo(self.newName) {
                screenshotManager.renameScreenshot(self.selected!, to: self.newName)
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.newName = ""
                    self.renaming = false
                    self.renameFieldFocus = false
                }
                
            }
        }
    }
}


//tuesday 23rd 10
