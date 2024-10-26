import SwiftUI

@main
struct BullyTracker_Watch_App: App {
    @StateObject var globalObject: GlobalObject
    @StateObject var backendRequests: BackendRequests
    @StateObject var healthKitManager: HKManager
    
    init() {
        // This is a mess, change later
        let global = GlobalObject()
        let HK = HKManager()
        HK.globalObject = global
        self._globalObject = StateObject(wrappedValue: global)
        self._backendRequests = StateObject(wrappedValue: global.backendRequests)
        self._healthKitManager = StateObject(wrappedValue: HK)
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
        .environmentObject(backendRequests)

    }
}
