import Foundation

class AlertManager: ObservableObject {
    var backendRequests: BackendRequests?
    
    private static let countdownLength = 5
    
    @Published var isSendingAlert: Bool
    @Published var countdown: Int
    private var timer: Timer?
    
    init() {
        self.isSendingAlert = false
        self.countdown = AlertManager.countdownLength
        self.timer = nil
    }
    
    // Start the countdown timer
    func startCountdown() {
        isSendingAlert = true
        self.countdown = AlertManager.countdownLength // Reset countdown
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                self.sendSOSAlert() // Send the SOS alert when countdown finishes
                self.stopTimer()
            }
        }
    }
    
    // Stop the countdown timer
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // Cancel the alert before the countdown finishes
    func cancelAlert() {
        self.stopTimer()
        self.isSendingAlert = false
    }
    
    // Function to send the SOS alert after the countdown
    private func sendSOSAlert() {
        self.backendRequests?.sendAlert()
        self.isSendingAlert = false
    }
    
}
