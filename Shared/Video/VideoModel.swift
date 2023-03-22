//
//  VideoModel.swift
//  Vjapp
//
//  Created by raku on 2022/03/05.
//

import Foundation
import AVFoundation
import SwiftUI


class ListModel:ObservableObject{
    @Published var listItems = [
        ListItemModel(URL(fileURLWithPath: ""),midiNote: 48),
        ListItemModel(URL(fileURLWithPath: ""),midiNote: 49),
                ListItemModel(URL(fileURLWithPath: ""),midiNote: 50),
                ListItemModel(URL(fileURLWithPath: ""),midiNote: 51)
//        ListItemModel(URL(fileURLWithPath: "/Users/rakutek/Movies/beeple/ribon.mp4")),
//        ListItemModel(URL(fileURLWithPath: "/Users/rakutek/Movies/beeple/fiber.mp4")),
//                ListItemModel(URL(fileURLWithPath: "/Users/rakutek/Movies/beeple/pray.mp4")),
//                ListItemModel(URL(fileURLWithPath: "/Users/rakutek/Movies/beeple/xannn.mp4"))
    ]
}

class ListItemModel:ObservableObject,Identifiable{
    @Published var val = 1.0
    @Published var midiNote:Int
    let id = UUID()
    let video: AVPlayer
    @Published var flag:Bool = false
    @Published var url: URL
    init(_ url: URL,midiNote: Int){
        self.url = url
        self.video = AVPlayer(url: url)
        self.midiNote = midiNote
    }

}

class ClipModel:ObservableObject{
    @Published var first = false
    @Published var id = UUID()
    @Published var url = URL(fileURLWithPath: "/Users/rakutek/Movies/beeple/ribon.mp4")
}
