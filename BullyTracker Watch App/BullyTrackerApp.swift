import SwiftUI

@main
struct BullyTracker_Watch_App: App {
    @StateObject var globalObject: GlobalObject
    
    init() {
        self._globalObject = StateObject(wrappedValue: GlobalObject())
    }
    
    var body: some Scene {
        WindowGroup {
            SOSScreen().environmentObject(globalObject)
        }
    }
}
