import SwiftUI

@main
struct BullyTracker_Watch_App: App {
    @StateObject var globalObject: GlobalObject = GlobalObject()
    
    var body: some Scene {
        WindowGroup {
            SOSScreen().environmentObject(globalObject)
        }
    }
}
