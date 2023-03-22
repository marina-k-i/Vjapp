//
//  ContentView.swift
//  Shared
//
//  Created by raku on 2022/02/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack{
            midiPickerView()
            HStack{
                PreViewView()
                    .frame(width: 300, height: 300)
                ClipGalleryView()
            }
            HStack{
                VideoList()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ExternalDisplayContent())
            .environmentObject(ListModel())
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
