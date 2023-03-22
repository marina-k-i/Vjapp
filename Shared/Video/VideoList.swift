//
//  VideoPlayer.swift
//  Vjapp
//
//  Created by raku on 2022/02/23.
//

import SwiftUI
import AVKit


struct VideoList: View {
    @EnvironmentObject var listModel : ListModel
    var body: some View {
        VStack{
            HStack{
                ForEach(self.listModel.listItems) { layer in
                    CompDetail(listItem: layer)
                }
                
            }
        }
    }
}



struct VideoList_Previews: PreviewProvider {
    static var previews: some View {
        VideoList()
            .environmentObject(ListModel())
            .preferredColorScheme(.dark)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}



