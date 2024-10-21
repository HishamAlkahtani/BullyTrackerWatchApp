//
//  AwaitingSetup.swift
//  BullyTracker Watch App
//
//  Created by Hisham Alkahtani on 18/04/1446 AH.
//

import SwiftUI

struct AwaitingSetup: View {
    var body: some View {
        VStack {
            ProgressView()
                .frame(width:1, height: 1, alignment:
                        .bottom)
            Text("Waiting for server...")
        }
    }
}

#Preview {
    AwaitingSetup()
}
