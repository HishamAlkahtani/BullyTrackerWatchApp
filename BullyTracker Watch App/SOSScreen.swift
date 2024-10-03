import SwiftUI

struct SOSScreen: View {
    @EnvironmentObject var globalObject: GlobalObject
    @EnvironmentObject var backendRequests: BackendRequests
    
    var body: some View {
        VStack {
            Text("ID: \(globalObject.watchId)").foregroundStyle(.gray)
            HStack{
                Image(systemName: "heart.fill").foregroundStyle(.red)
                Text(": \(globalObject.heartRate)")
            }
            Button("SOS"){
                backendRequests
                    .sendAlert()
            }.tint(.red).transition(.opacity).padding()
        }.padding()
    }
    
    
}
    
    

