import Foundation

// Initializes program and holds the data to be shared with views that need it
class GlobalObject: ObservableObject {
    var locationManager: LocationManager
    var backendRequests: BackendRequests
    @Published var watchId: String
    
    // for now it's a string, just to test HR is being read properly
    @Published var heartRate: String
    
    init() {
        self.locationManager = LocationManager()
        self.watchId = "0"
        self.backendRequests = BackendRequests()
        self.heartRate = "N/A"
        backendRequests.globalObject = self
        
        initWatchId()
    }
    
    /* look for watchId in storage, if not found
        ask server to assign watchId */
    func initWatchId() {
        do {
            let tempId = try DataStore.loadWatchId()
            if tempId == "0" {
                backendRequests.getWatchIdFromServer()
            } else {
                self.watchId = tempId
            }
        } catch {
            backendRequests.getWatchIdFromServer()
        }
    }
}
