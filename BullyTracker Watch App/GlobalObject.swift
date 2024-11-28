import Foundation

// Initializes program and holds the data to be shared with views that need it
class GlobalObject: ObservableObject {
    var locationManager: LocationManager
    var backendRequests: BackendRequests
    var alertManager: AlertManager
    var fallDetection: FallDetectionManager?
    var hkManager: HKManager
    
    @Published var watchId: String
    @Published var isActive: Bool
    @Published var schoolName: String?

    
    // for now it's a string, just to test HR is being read properly
    @Published var heartRate: String
    
    init() {
        self.watchId = "0"
        self.backendRequests = BackendRequests()
        self.heartRate = "NA"
        self.isActive = false
        self.alertManager = AlertManager()
        self.hkManager = HKManager()
        self.locationManager = LocationManager()
        self.fallDetection = nil
        
        self.hkManager.globalObject = self
        self.alertManager.backendRequests = self.backendRequests
        self.backendRequests.globalObject = self
        self.locationManager.backendRequests = self.backendRequests
        self.locationManager.globalObject = self
     
        self.initAppData()
    }
    
    func initFallDetection () {
        self.fallDetection = FallDetectionManager()
        self.fallDetection!.alertManager = self.alertManager
    }
    
    /* look for watchId in storage, if not found
        ask server to assign watchId */
    func initAppData() {
        do {
            let appData = try DataStore.loadAppData()
            self.watchId = appData.watchId!
            self.isActive = appData.isActive
            self.schoolName = appData.schoolName
            
            // if watch is not active, it has not been setup yet.
            if (!isActive) {
                backendRequests.initSetupProcess()
            } else {
                backendRequests.initStatusChecks()
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
    
    func printAppState() {
        print("\(isActive) \(watchId) \(schoolName)")
    }
}
