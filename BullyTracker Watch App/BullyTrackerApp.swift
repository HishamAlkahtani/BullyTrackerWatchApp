import SwiftUI

@main
struct BullyTracker_Watch_App: App {
    @StateObject var globalObject: GlobalObject
    @StateObject var alertManager: AlertManager

    init() {
        // This is a mess, change later
        let global = GlobalObject()
        self._globalObject = StateObject(wrappedValue: global)
        self._alertManager = StateObject(wrappedValue: global.alertManager)
    }
    
    var body: some Scene {
        WindowGroup {
            if globalObject.watchId == "0" || !globalObject.isActive {
                AwaitingSetup()
            } else {
                SOSScreen()
            }
        }
        .environmentObject(globalObject)
        .environmentObject(alertManager)

    }
}
