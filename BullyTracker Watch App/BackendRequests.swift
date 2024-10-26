import Foundation

// Handles all communications with backend server
class BackendRequests: ObservableObject {
    private let baseURL = 
        //"https://BTProto.pythonanywhere.com"
        "http://127.0.0.1:5000/watchAPI"
    
    // for periodic requests
    private let sleepInterval = 3.0;
    
    var globalObject: GlobalObject!
    
    func initSetupProcess() {
        setup();
    }
    
    private func setup() {
        print("Checking setup status...")
        let url = URL(string: "\(baseURL)/checkSetupStatus/\(globalObject.watchId)")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in

            guard let data = data else {
                print("Could not get app data...")
                self.retrySetup()
                return
            }
            
            let appData: AppData
            do {
                appData = try JSONDecoder().decode(AppData.self, from: data)
            } catch {
                print("Could not parse server response")
                self.retrySetup()
                return
            }
            
            if appData.schoolName == nil {
                self.retrySetup()
            } else {
                DispatchQueue.main.async {
                    self.globalObject.schoolName = appData.schoolName
                    print("School name recieved successfully!")
                }
            }
        }
        
        task.resume()
    }
    
    private func retrySetup() {
        Thread.sleep(forTimeInterval: sleepInterval)
        URLSession.shared.reset() {
            self.setup()
        }
    }
    
    func acceptSetup() {
        globalObject.isActive = true;
        postAppData()
    }
    
    func rejectSetup() {
        globalObject.schoolName = nil;
        postAppData()
    }
    
    private func postAppData() {
        var dataDict: [String: Any] = ["watchId": globalObject.watchId,
                       "isActive": globalObject.isActive]
        
        if globalObject.schoolName != nil {
            dataDict.updateValue(globalObject.schoolName!, forKey: "schoolName")
        }
        
        let data: Data;
        
        do {
            data = try JSONSerialization.data(withJSONObject: dataDict)
        } catch{
            return
        }
        
        let url = URL(string:"\(baseURL)/checkSetupStatus/\(globalObject.watchId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = data
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else {
                print("Could not get server response after accepting setup")
                self.setup()
                return
            }
            
            let appData: AppData
            do {
                appData = try JSONDecoder().decode(AppData.self, from: data)
            } catch {
                print("could not parse server response")
                return
            }
            
            if appData.isActive != self.globalObject.isActive {
                print("isActive mismatch! (this should never happen)")
                return
            }
            
            if !appData.isActive {
                self.setup()
            }
        }
        
        task.resume()
    }
    
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
                self.globalObject.storeAppData()
                self.setup()
                print("Successfully recieved watchId")
            }
            
        }
        
        task.resume()
    }
    
    // sleeps for 3 seconds, resets shared URLSession, then attempts to getWatchId again
    private func retryGettingWatchId() {
        Thread.sleep(forTimeInterval: sleepInterval)
        URLSession.shared.reset() {
            self.getWatchIdFromServer()
        }
    }
    
}

private struct WatchIdJsonObject: Codable {
    let watchId: String
}
