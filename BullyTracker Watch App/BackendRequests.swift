import Foundation

// Handles all communications with backend server
class BackendRequests: ObservableObject {
    private let baseURL = 
        "https://BTProto.pythonanywhere.com"
        // "http://127.0.0.1:5000"
    var globalObject: GlobalObject!
    
    func sendAlert() {
        let wId = globalObject.watchId
        let location = globalObject.locationManager.getMostRecentLocation()
        let url = URL(string: "\(baseURL)/alert/\(wId)/\(location) HR: \(globalObject.heartRate)")!
        
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
                self.retryGettingWatchId()
                return
            }
            
            let recievedWatchId: String
            do {
                recievedWatchId = try JSONDecoder().decode(WatchIdJsonObject.self, from: data).watchId
            } catch {
                print("Could not parse server response, trying again to get watchId")
                self.retryGettingWatchId()
                return
            }
            
            DispatchQueue.main.async {
                self.globalObject.watchId = recievedWatchId
                print("Successfully recieved watchId")
            }
            
            do {
                try DataStore.saveWatchId(recievedWatchId)
            } catch {
                print("Failed to store watchId!!!")
            }
        }
        
        task.resume()
    }
    
    // sleeps for 3 seconds, resets shared URLSession, then attempts to getWatchId again
    private func retryGettingWatchId() {
        // retry getting watchId after 3 seconds
        Thread.sleep(forTimeInterval: 3)

        // URLSession is reset to ensure a new attempt at a connection
        // is made with every attempt... URLSession.reset() is async
        // thus the closure...
        URLSession.shared.reset() {
            self.getWatchIdFromServer()
        }
    }
    
}

private struct WatchIdJsonObject: Codable {
    let watchId: String
}
