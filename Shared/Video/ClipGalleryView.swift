//
//  ClipGalleryView.swift
//  Vjapp (iOS)
//
//  Created by raku on 2022/03/15.
//

import SwiftUI
import UniformTypeIdentifiers

struct ClipGalleryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var isImporting: Bool = false
    @EnvironmentObject var clipmodel : ClipModel
    @EnvironmentObject var listModel : ListModel
    
    var body: some View {
        VStack{
            Spacer()
            Button(action: {
                isImporting = false
                
                //fix broken picker sheet
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isImporting = true
                }
            }, label: {
                Text("Import")
            })
            List {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 4), count: 7)){
                    ForEach(items) { item in
                        if let path = item.img_path {
                            ImagView(img_path: path, url: item.url!)
                        }else {
                            Text(item.url!.absoluteString)
                        }
                        
                    }
                }
            }
            
        }
        .fileImporter(
            isPresented: $isImporting,
            //            allowedContentTypes: [UTType.plainText],
            allowedContentTypes: [UTType.movie],
            allowsMultipleSelection: true
        ) { result in
            do {
                
                for res in try result.get() {
                    addUrl(url: res)
                    CFURLStopAccessingSecurityScopedResource(res as CFURL)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func addUrl(url: URL) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.url = url
            // もともとの画像URL
            let myImageName = url.absoluteString.replacingOccurrences(of:"/", with:"=") // 変換
            let imagePath = fileInDocumentsDirectory(filename: myImageName)
            
            if let p = thumnailImageForFileUrl(fileUrl: url) {
                if saveImage(image: p, path: imagePath){
                    newItem.img_path = imagePath
                } else{print("失敗！")}
            }
            
            //            thumnailImageForFileUrl(fileUrl: url!)!
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

struct ClipGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        ClipGalleryView()
            .environmentObject(ListModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.landscapeRight)
        
    }
}
