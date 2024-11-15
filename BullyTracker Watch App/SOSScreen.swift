import SwiftUI

struct SOSScreen: View {
    @EnvironmentObject var globalObject: GlobalObject
    @EnvironmentObject var backendRequests: BackendRequests
    @EnvironmentObject var alertManager: AlertManager

    var body: some View {
        VStack {
            // Show cancel alert view when the countdown is active
            if self.alertManager.isSendingAlert {
                VStack {
                    Text("Sending SOS in:")
                        .font(.headline)
                        .padding()
                    
                    Text("\(self.alertManager.countdown)s")
                    // Cancel button
                    Button("Cancel SOS") {
                        self.alertManager.cancelAlert()
                    }
                    .tint(.blue)
                    .transition(.slide)
                    .padding()
                }
                .padding().transition(.scale)
            } else {
                VStack {
                    Text("ID: \(globalObject.watchId)").foregroundStyle(.gray)
                    HStack{
                        Image(systemName: "heart.fill").foregroundStyle(.red)
                        Text(": \(globalObject.heartRate)")
                    }
                    Button("SOS"){
                        self.alertManager.startCountdown()
                    }.tint(.red).padding()
                }.padding().transition(.scale)
            }
            
        }
        .transition(.slide)
        .padding()
        .onDisappear {
            self.alertManager.stopTimer()
        }
        .sensoryFeedback(.warning, trigger: self.alertManager.countdown)
    }
}
