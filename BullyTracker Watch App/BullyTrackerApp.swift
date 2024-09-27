import SwiftUI

var locationManager: LocationManager?

@main
struct BullyTracker_Watch_App: App {
    init () {
        locationManager = LocationManager()
    }
    
    var body: some Scene {
        WindowGroup {
            SOSScreen()
        }
    }
}
