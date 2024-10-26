import Foundation

// Initializes program and holds the data to be shared with views that need it
class GlobalObject: ObservableObject {
    var locationManager: LocationManager
    var backendRequests: BackendRequests
    
    @Published var watchId: String
    @Published var isActive: Bool
    @Published var schoolName: String?

    // for now it's a string, just to test HR is being read properly
    @Published var heartRate: String
    
    init() {
        self.locationManager = LocationManager()
        self.watchId = "0"
        self.backendRequests = BackendRequests()
        self.heartRate = "N/A"
        self.isActive = false
        backendRequests.globalObject = self
        initAppData()
    }
    
    /* look for watchId in storage, if not found
        ask server to assign watchId */
    func initAppData() {
        do {
            let appData = try DataStore.loadAppData()
            self.watchId = appData.watchId!
            self.isActive = appData.isActive
            self.schoolName = appData.schoolName
            
            if (!isActive) {
                backendRequests.initSetupProcess()
            }
        } catch {
            backendRequests.getWatchIdFromServer()
        }
    }
    
    func storeAppData() {
        do {
            try DataStore.saveAppData(AppData(watchId: self.watchId, isActive: self.isActive, schoolName: self.schoolName))
        } catch {
            print("Failed to store app data!")
        }
    }
    
    func getAppData() -> AppData {
        return AppData(watchId: self.watchId, isActive: self.isActive, schoolName: self.schoolName)
    }
}
