//
//  thumb.swift
//  keseData
//
//  Created by raku on 2022/03/14.
//

import Foundation
import AVFoundation
import AVKit

//extension AVAsset {
//    
//    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
//        DispatchQueue.global().async {
//            let imageGenerator = AVAssetImageGenerator(asset: self)
//            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
//            let times = [NSValue(time: time)]
//            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
//                if let image = image {
//                    completion(UIImage(cgImage: image, scale: 0, orientation: .right))
//                } else {
//                    completion(nil)
//                }
//            })
//        }
//    }
//}

func thumnailImageForFileUrl(fileUrl: URL) -> UIImage? {
    print(fileUrl.startAccessingSecurityScopedResource())
    do {
        let bookmarkData = try fileUrl.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: fileUrl.absoluteString)
    }
    catch let error {
        print(error.localizedDescription)
    }
    
    let asset = AVAsset(url: fileUrl)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    
    do {
        let thumnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
        print("サムネイルの切り取り成功！")
        return UIImage(cgImage: thumnailCGImage, scale: 0, orientation: .up).scaleImage(scaleSize: 0.035)
        
    }catch let err{
        print("エラー\(err)")
    }
    return nil
}



extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
