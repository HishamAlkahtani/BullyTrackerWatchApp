//
//  AwaitingSetup.swift
//  BullyTracker Watch App
//
//  Created by Hisham Alkahtani on 18/04/1446 AH.
//

import SwiftUI

struct AwaitingSetup: View {
    @EnvironmentObject var globalObject: GlobalObject
    @EnvironmentObject var backendRequests: BackendRequests
    
    var body: some View {
        VStack {
            if globalObject.schoolName == nil {
                ProgressView()
                    .frame(width:1, height: 1, alignment:
                            .bottom)
                if globalObject.watchId == "0" {
                    Text("Waiting for server...")
                } else if globalObject.schoolName == nil {
                    Text("WatchId: \(globalObject.watchId)")
                    Text("Waiting to be setup...")
                }
            } else {
                Text("School \(globalObject.schoolName!) is trying to connect to this watch")
                HStack {
                    Button("Accept") {
                        backendRequests.acceptSetup()
                    }
                    Button ("Reject") {
                        backendRequests.rejectSetup()
                    }
                }
            }
                
            
        }
    }
}

#Preview {
    AwaitingSetup()
}
