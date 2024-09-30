import Foundation

/*
    If more data storage is needed, move watchId inside dataStore and make it
    encapsulate all data related functionalities. For now this is fine.
 */

// Initializes program and holds the data to be shared with views that need it
class GlobalObject: ObservableObject {
    var locationManager: LocationManager
    @Published var watchId: Int
    var dataStore: DataStore
    
    init() {
        self.locationManager = LocationManager()
        self.watchId = 0
        self.dataStore = DataStore()
        
        initWatchId()
    }
    
    /* look for watchId in storage, if not found
        ask server to assign watchId */
    func initWatchId() {
        do {
            let tempId = try self.dataStore.loadWatchId()
            if tempId == 0 {
                getWatchIdFromServer()
            } else {
                self.watchId = tempId
            }
        } catch {
            getWatchIdFromServer()
        }
    }
    
    // Get watch id from server and update it whenever the id arrives
    func getWatchIdFromServer() {
        let url = URL(string: "https://BTProto.pythonanywhere.com/getWatchId")!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {
                print("Request to server failed: Could not get watchId")
                return
            }
            guard let recievedWatchId = Int(String(data: data, encoding: .utf8)!) else {
                print("Invalid watchId response")
                return
            }
            DispatchQueue.main.async {
                self.watchId = recievedWatchId
                print("Successfully recieved watchId")
            }
            
            do {
                try self.dataStore.saveWatchId(recievedWatchId)
            } catch {
                print("Failed to store watchId!")
            }
        }
        
        task.resume()
    }
}
