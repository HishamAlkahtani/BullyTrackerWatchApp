import Foundation
import CoreMotion

// Sets up and monitors fall detection api and notifies the app if the student falls
class FallDetectionManager: NSObject, CMFallDetectionDelegate {
    let manager: CMFallDetectionManager?
    var alertManager: AlertManager?
    
    override init() {
        if CMFallDetectionManager.isAvailable {
            self.manager = CMFallDetectionManager()
            print ("Fall detection available")
        } else {
            print("Failed to initiate fall detection!")
            self.manager = nil
        }
        self.alertManager = nil
        super.init()
        
        manager?.delegate = self
        
        if manager?.authorizationStatus == .notDetermined || manager?.authorizationStatus == .denied {
            
            manager?.requestAuthorization {
                authorizationStatus in
                print (authorizationStatus)
            }
        }
        
    }
    
    func fallDetectionManager(
        _ fallDetectionManager: CMFallDetectionManager,
        didDetect event: CMFallDetectionEvent,
        completionHandler handler: @escaping () -> Void
    ) {
        alertManager?.startCountdown()
        print ("FALL HAS BEEN DETECTED!")
        handler()
    }
}
