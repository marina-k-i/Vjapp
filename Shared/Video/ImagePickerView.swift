//
//  ImagePickerView.swift
//  Vjapp
//
//  Created by raku on 2022/03/05.
//

import SwiftUI
import CoreData


// ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL!.path
}
// DocumentディレクトリのfileURLを取得
func getDocumentsURL() -> NSURL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    return documentsURL
}


func saveImage (image: UIImage, path: String ) -> Bool {
    let pngImageData = image.pngData()
    do {
        try pngImageData!.write(to: URL(fileURLWithPath: path), options: .atomic)
    } catch {
        print(error)
        return false
    }
    return true
}

struct ImagView: View {
    @EnvironmentObject var clipmodel : ClipModel
    @EnvironmentObject var listModel : ListModel
    var img_path:String
    var url:URL
    var body: some View{
        VStack{
            Image( uiImage: UIImage(contentsOfFile: fileInDocumentsDirectory(filename: url.absoluteString.replacingOccurrences(of:"/", with:"=")))!)
                .onTapGesture {
                    if clipmodel.first{
                        clipmodel.url=url
                        listModel.listItems.filter {$0.id == clipmodel.id}[0].flag = true
                        listModel.listItems.filter {$0.id == clipmodel.id}[0].url = url
                        //                                    非同期で再描画する
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            listModel.listItems.filter {$0.id == clipmodel.id}[0].flag = false
                            
                        }
                    }
                    
                }
        }
    }
    
}
