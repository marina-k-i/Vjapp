//
//  ExternalView.swift
//  Screens
//
//  Created by Prathamesh Kowarkar on 07/10/20.
//

import SwiftUI

struct PreViewView: View {
    @EnvironmentObject var externalDisplayContent: ExternalDisplayContent
    @EnvironmentObject var listModel : ListModel
    
    var body: some View {
        ZStack{
            ForEach(listModel.listItems) { listItem in
                ViVIew(listItem: listItem)
            }
        }
    }
}

struct ExternalView: View {
    @EnvironmentObject var externalDisplayContent: ExternalDisplayContent
    @EnvironmentObject var listModel : ListModel
    
    var body: some View {
        ZStack{
            ForEach(listModel.listItems) { listItem in
                ViVIew(listItem: listItem)
            }
        }.background(Color.black)
    }
}


struct ViVIew: View {
    
    @ObservedObject var listItem:ListItemModel
    @EnvironmentObject var clipmodel : ClipModel
    var body: some View {
        VStack{
            if listItem.id == clipmodel.id && listItem.flag {
                LoopingPlayer(listItem: listItem)
                    .opacity(listItem.val)
            }
            else{
                LoopingPlayer(listItem: listItem)
                    .opacity(listItem.val)
            }
            
        }
    }
}




struct ExternalView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .environmentObject(ExternalDisplayContent())
            .environmentObject(ListModel())
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(ClipModel())
    }
    
}
