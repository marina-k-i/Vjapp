//
//  LoopingPlayer.swift
//  LoopingPlayer
//
//  Created by SchwiftyUI on 3/28/20.
//  Copyright © 2020 SchwiftyUI. All rights reserved.
//

import SwiftUI
import AVFoundation

struct LoopingPlayer: UIViewRepresentable {
    @ObservedObject var listItem:ListItemModel
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(frame: .zero,listItem: listItem)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing here
    }
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    init(frame: CGRect,listItem:ListItemModel) {
        super.init(frame: frame)
        var url: URL = listItem.url
        if let urlData = UserDefaults.standard.data(forKey: listItem.url.absoluteString) {
            do {
                var isStale = false
                url = try URL(resolvingBookmarkData: urlData, bookmarkDataIsStale: &isStale)
//                print(url)
                
                if isStale == true {
                    print("err")
                }
//                print("UserDefaults:\(url)")
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        
        
        
        // Load Video
        let playerItem = AVPlayerItem(url: url)
        
        // Setup Player
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        player.volume = 0.0
        
        // Loop
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        // Play
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct LoopingPlayer_Previews: PreviewProvider {
    static var previews: some View {
        LoopingPlayer(listItem:  ListItemModel( URL(fileURLWithPath: "/Users/rakutek/Movies/beeple/fiber.mp4"),midiNote: 48))
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
