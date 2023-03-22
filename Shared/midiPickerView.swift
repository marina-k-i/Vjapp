//
//  midiPicker.swift
//  Vjapp
//
//  Created by raku on 2022/03/16.
//

import SwiftUI
import MIDIKit

struct midiPickerView: View {
    @EnvironmentObject var midiManager: AppDelegate
    @State var midiInputConnectionEndpoint: MIDI.IO.OutputEndpoint? = nil
    @State var val:Double = 0.0
    @EnvironmentObject var listModel : ListModel
    let kInputTag = "EventLoggerInput"
    let kInputName = "MIDIKit Event Logger In"
    
    let kOutputTag = "EventLoggerOutput"
    let kOutputName = "MIDIKit Event Logger Out"
    
    let kInputConnectionTag = "EventLoggerInputConnection"
    
    private func receivedMIDIEvent(_ event: MIDI.Event) {
        switch event {
        case .noteOn(let payload):
            print("NoteOn:", payload.note, payload.velocity, payload.channel)
        case .noteOff(let payload):
            print("NoteOff:", payload.note, payload.velocity, payload.channel)
        case .cc(let payload):
            //            print("CC:", payload.controller, payload.value, payload.channel)
            //            print( payload.controller.name,payload.controller.number)
            if !listModel.listItems.filter({$0.midiNote == Int(payload.controller.number)}).isEmpty {
                listModel.listItems.filter {$0.midiNote == Int(payload.controller.number)}[0].val = payload.value.unitIntervalValue
            }
            //            val = payload.value.unitIntervalValue
        case .programChange(let payload):
            print("PrgCh:", payload.program, payload.channel)
            
            // etc...
            
        default:
            break
        }
    }
    
    func updateInputConnection() {
        
        // check for existing connection and compare new selection against it
        if let ic = midiManager.midiManager.managedInputConnections[kInputConnectionTag] {
            // if endpoint is the same, don't reconnect
            if ic.endpoints.first == midiInputConnectionEndpoint {
                print("Already connected.")
                return
            }
        }
        
        if !midiManager.midiManager.managedInputConnections.isEmpty {
            print("Removing input connections.")
            midiManager.midiManager.remove(.inputConnection, .all)
        }
        
        guard let endpoint = midiInputConnectionEndpoint else { return }
        
        //        let endpointName = (endpoint.getDisplayName() ?? endpoint.name).quoted
        let endpointName = (endpoint.getDisplayName() ?? endpoint.name)
        
        print("Setting up new input connection to \(endpointName).")
        
        func stdWeight() {
            
            print("fdjsaklfjdls;ajfklsdajfl")
        }
        
        
        do {
            try midiManager.midiManager.addInputConnection(
                toOutputs: [.uniqueID(endpoint.uniqueID)],
                tag: kInputConnectionTag,
                //                receiveHandler: .eventsLogging()
                receiveHandler: .events {  events in
                    // Note: this handler will be called on a background thread
                    // so call the next line on main if it may result in UI updates
                    DispatchQueue.main.async {
                        events.forEach { self.receivedMIDIEvent($0) }
                    }
                }
            )
            
            
        } catch {
            print(error)
        }
    }
    
    
    
    var body: some View {
        
        ReceiveMIDIEventsView()
    }
}

extension midiPickerView {
    
    func ReceiveMIDIEventsView() -> some View {
        VStack{
            Picker("", selection: $midiInputConnectionEndpoint) {
                Text("None")
                    .tag(MIDI.IO.OutputEndpoint?.none)
                
                ForEach(midiManager.midiManager.endpoints.outputs) {
                    Text($0.getDisplayName() ?? $0.name)
                        .tag(MIDI.IO.OutputEndpoint?.some($0))
                }
            }
            Button("接続"){
                updateInputConnection()
                print(midiManager.midiManager.endpoints.outputs)
            }
        }
    }
}


struct midiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        midiPickerView()
            .environmentObject(AppDelegate())
            .environmentObject(ListModel())
    }
}


