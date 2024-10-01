import Foundation

// Handles all communications with backend server
class BackendRequests: ObservableObject {
    private let baseURL = "https://BTProto.pythonanywhere.com"
    var globalObject: GlobalObject!
    
    func sendAlert() {
        let wId = globalObject.watchId
        let location = globalObject.locationManager.getMostRecentLocation()
        let url = URL(string: "\(baseURL)/alert/\(wId)/\(location)")!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {return }
            guard let response = String(data: data, encoding: .utf8) else {return}
            print (response)
        }
        
        task.resume()
    }
    
    // Get watch id from server and update it whenever the id arrives
    func getWatchIdFromServer() {
        let url = URL(string: "\(baseURL)/getWatchId")!
        
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
                self.globalObject.watchId = recievedWatchId
                print("Successfully recieved watchId")
            }
            
            do {
                try DataStore.saveWatchId(recievedWatchId)
            } catch {
                print("Failed to store watchId!")
            }
        }
        
        task.resume()
    }
    
}
