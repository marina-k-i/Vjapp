//
//  VjappApp.swift
//  Shared
//
//  Created by raku on 2022/02/23.
//

import SwiftUI
import Combine
import MIDIKit

@main
struct VjappApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    @ObservedObject var externalDisplayContent = ExternalDisplayContent()
//    @ObservedObject var modelData = ModelData()
    @ObservedObject var listmodel = ListModel()
    @ObservedObject var clipmodel = ClipModel()
    @State var additionalWindows: [UIWindow] = []
    let persistenceController = PersistenceController.shared

    
    private var screenDidConnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didConnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private var screenDidDisconnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didDisconnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(externalDisplayContent)
//                .environmentObject(modelData)
                .environmentObject(listmodel)
                .environmentObject(clipmodel)
                .onReceive(
                    screenDidConnectPublisher,
                    perform: screenDidConnect
                )
                .onReceive(
                    screenDidDisconnectPublisher,
                    perform: screenDidDisconnect
                ).environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(
                    MIDI.IO.Manager(clientName: "MIDIEventLogger",
                                    model: "LoggerApp",
                                    manufacturer: "Orchetect")
                )
            
        }
    }
    
    private func screenDidConnect(_ screen: UIScreen) {
        let window = UIWindow(frame: screen.bounds)
        
        window.windowScene = UIApplication.shared.connectedScenes
            .first { ($0 as? UIWindowScene)?.screen == screen }
        as? UIWindowScene
        
        let view = ExternalView()
            .environmentObject(externalDisplayContent)
//            .environmentObject(modelData)
            .environmentObject(listmodel)
            .environmentObject(clipmodel)
        let controller = UIHostingController(rootView: view)
        window.rootViewController = controller
        window.isHidden = false
        additionalWindows.append(window)
        externalDisplayContent.isShowingOnExternalDisplay = true
    }
    
    private func screenDidDisconnect(_ screen: UIScreen) {
        additionalWindows.removeAll { $0.screen == screen }
        externalDisplayContent.isShowingOnExternalDisplay = false
    }
}


class AppDelegate: NSObject, UIApplicationDelegate,ObservableObject {
    
    @Published var midiManager: MIDI.IO.Manager = {
        var newManager = MIDI.IO.Manager(
            clientName: "MIDIEventLogger",
            model: "LoggerApp",
            manufacturer: "Orchetect")
        
//        { notification, manager in
//            print("Core MIDI notification:", notification)
//        }
        do {
            print("Starting MIDI manager")
            try newManager.start()
        } catch {
            print(error)
        }
        
        // uncomment this to test different API versions or limit to MIDI 1.0 protocol
        //newManager.preferredAPI = .legacyCoreMIDI
        
        return newManager
    }()
}
