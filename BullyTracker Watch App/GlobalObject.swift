import Foundation

// TODO: watchId should be stored locally, only call server to assign id for the first time program is run

// Initializes program and holds the data to be shared with views that need it
class GlobalObject: ObservableObject {
    var locationManager: LocationManager
    @Published var watchId: Int
    
    init() {
        self.locationManager = LocationManager()
        self.watchId = 0
        
        getWatchIdFromServer()
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
            }
        }
        
        task.resume()
    }
}
