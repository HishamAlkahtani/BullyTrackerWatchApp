import SwiftUI

struct SOSScreen: View {
    @EnvironmentObject var globalObject: GlobalObject
    @EnvironmentObject var backendRequests: BackendRequests

    
    @State private var isSendingAlert = false
    @State private var countdown = 5
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            // Show cancel alert view when the countdown is active
            if isSendingAlert {
                VStack {
                    Text("Sending SOS in:")
                        .font(.headline)
                        .padding()
                    
                    Text("\(countdown)s")
                    // Cancel button
                    Button("Cancel SOS") {
                        cancelAlert()
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
                        startCountdown()
                    }.tint(.red).padding()
                }.padding().transition(.scale)
            }
            
        }
        .transition(.slide)
        .padding()
        .onDisappear {
            stopTimer()
        }
        .sensoryFeedback(.warning, trigger: countdown)
    }
    
    // Start the countdown timer
    private func startCountdown() {
        isSendingAlert = true
        countdown = 5 // Reset countdown
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                sendSOSAlert() // Send the SOS alert when countdown finishes
                stopTimer()
            }
        }
    }
    
    // Stop the countdown timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Cancel the alert before the countdown finishes
    private func cancelAlert() {
        stopTimer()
        isSendingAlert = false
    }
    
    // Function to send the SOS alert after the countdown
    private func sendSOSAlert() {
        backendRequests.sendAlert()
        isSendingAlert = false
    }
}
