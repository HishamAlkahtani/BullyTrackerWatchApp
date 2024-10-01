import SwiftUI

@main
struct BullyTracker_Watch_App: App {
    @StateObject var globalObject: GlobalObject
    @StateObject var backendRequests: BackendRequests
    
    init() {
        let global = GlobalObject()
        self._globalObject = StateObject(wrappedValue: global)
        self._backendRequests = StateObject(wrappedValue: global.backendRequests)
    }
    
    var body: some Scene {
        WindowGroup {
            SOSScreen()
                .environmentObject(globalObject)
                .environmentObject(backendRequests)
        }
    }
}
