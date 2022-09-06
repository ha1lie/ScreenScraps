//
//  PopUpView.swift
//  ScreenScraps
//
//  Created by Hallie on 8/12/22.
//

import SwiftUI

struct PopUpView: View {
    let message: String
    let image: String?
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text(self.message)
                    .lineLimit(1)
                if let image = self.image {
                    Image(systemName: image)
                }
            }.frame(width: 200, height: 50)
                
        }.background(.thinMaterial, in: RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 5)
        .padding()
    }
}
