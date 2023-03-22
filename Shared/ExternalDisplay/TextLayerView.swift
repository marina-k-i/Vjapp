//
//  TextLayerView.swift
//  Vjapp (iOS)
//
//  Created by raku on 2022/03/15.
//

import SwiftUI

struct TextLayerView: View {
    @State var position: CGSize = CGSize(width: 200, height: 200)
    
    var body: some View {
        VStack {
            Text("Diplo")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color.white)
                .position(x: position.width, y: position.height)
                .gesture(
                    DragGesture().onChanged { value in
                        self.position = CGSize(
                            width: value.startLocation.x + value.translation.width,
                            height: value.startLocation.y + value.translation.height
                        )
                    }
                        .onEnded { value in
                            self.position = CGSize(
                                width: value.startLocation.x + value.translation.width,
                                height: value.startLocation.y + value.translation.height
                            )
                        }
                )
            Spacer()
            Text("x:\(position.width), y:\(position.height)")
        }
    }
}

struct TextLayerView_Previews: PreviewProvider {
    static var previews: some View {
        TextLayerView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
