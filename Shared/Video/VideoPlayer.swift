//
//  VideoPlayer.swift
//  Vjapp
//
//  Created by raku on 2022/02/23.
//

import SwiftUI
import AVKit


struct VideoPlayer: View {
    var body: some View {
        HStack{
            ForEach(layers) { layer in
                Comp(layer: layer)
            }
        }
    }
}

struct Comp: View {
    var layer: Layer
    @State private var value = 0.7
    @State var isPlaying: Bool = false
    
    var body: some View {
        
        HStack{
            VStack {
                PlayerView(player: layer.video)
                    .opacity(value)
                    .frame(width: 300, height: 300)
                Button(action: {
                    self.isPlaying.toggle()
                    if(isPlaying){
                        layer.video.play()
                    }else{layer.video.pause()}
                }) {
                    if isPlaying {
                        Image(systemName: "pause")
                    } else {
                        Image(systemName: "play")
                    }
                }
            }
            
            Slider(value: $value, in: 0.0...1.0)
                .rotationEffect(.degrees(-90.0), anchor: .topLeading)
                .frame(width: 300,height: 10)
                .offset(y: 300)
        }
        
    }
}

struct VideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayer()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}



