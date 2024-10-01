import Foundation

/*
    If more data storage is needed, move watchId inside dataStore and make it
    encapsulate all data related functionalities. For now this is fine.
 */

// Initializes program and holds the data to be shared with views that need it
class GlobalObject: ObservableObject {
    var locationManager: LocationManager
    var backendRequests: BackendRequests
    @Published var watchId: Int
    
    init() {
        self.locationManager = LocationManager()
        self.watchId = 0
        self.backendRequests = BackendRequests()
        backendRequests.globalObject = self
        
        initWatchId()
    }
    
    /* look for watchId in storage, if not found
        ask server to assign watchId */
    func initWatchId() {
        do {
            let tempId = try DataStore.loadWatchId()
            if tempId == 0 {
                backendRequests.getWatchIdFromServer()
            } else {
                self.watchId = tempId
            }
        } catch {
            backendRequests.getWatchIdFromServer()
        }
    }
}
