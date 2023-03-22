//
//  CompDetail.swift
//  Vjapp
//
//  Created by raku on 2022/03/05.
//

import SwiftUI
import AVKit


struct CompDetail: View {
    @ObservedObject var listItem:ListItemModel
    @State var isPlaying: Bool = false
    @EnvironmentObject var clipmodel : ClipModel
    @State private var flag = false
    var body: some View {
        
        HStack{
            VStack {
                VStack{
                    
                    if listItem.id == clipmodel.id && listItem.flag {
                        LoopingPlayer(listItem: listItem)
                            .frame(width: 300, height: 170)
                    }
                    else{
                        LoopingPlayer(listItem: listItem)
                            .frame(width: 300, height: 170)
                    }
                }.onTapGesture {
                    if !clipmodel.first {
                        clipmodel.first.toggle()
                    }
                    clipmodel.id = listItem.id
                }
                Slider(value: $listItem.val, in: 0.0...1.0)
            }.background(clipmodel.id == listItem.id ? Color.gray.opacity(0.3) : Color.black)
            .frame(width:300)
        }
    }
}

struct CompDetail_Previews: PreviewProvider {
    static var previews: some View {
        CompDetail(listItem:
                    ListItemModel( URL(fileURLWithPath: "/Users/rakutek/Movies/test.mp4"),midiNote: 48))
            .preferredColorScheme(.dark)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(ClipModel())
    }
}
