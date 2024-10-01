import SwiftUI

struct SOSScreen: View {
    @EnvironmentObject var globalObject: GlobalObject
    @EnvironmentObject var backendRequests: BackendRequests
    
    var body: some View {
        VStack {
            Text("\(globalObject.watchId)").foregroundStyle(.gray).padding()
            Button("SOS"){
                backendRequests
                    .sendAlert()
            }.tint(.red).transition(.opacity).padding()
        }.padding()
    }
    
    
}
    
    

