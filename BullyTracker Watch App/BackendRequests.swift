import Foundation
import CoreLocation

// Handles all communications with backend server
class BackendRequests: ObservableObject {
    private let baseURL = 
        "https://BTProto.pythonanywhere.com/watchAPI"
        //"http://127.0.0.1:5000/watchAPI"
    
    private let secondsBetweenSetupUpdateRequests = 3.0;
    private let secondsBetweenStatusCheck = 45.0;
    private var setupInProgress: Bool = false
    
    var globalObject: GlobalObject!
    
    func initSetupProcess() {
        setupInProgress = true
        setup()
    }
    
    func initStatusChecks() {
        self.checkWatchStatus()
    }
    
    private func setup() {
        print("Setup In Progress, Checking setup status...")
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
        Thread.sleep(forTimeInterval: secondsBetweenSetupUpdateRequests)
        URLSession.shared.reset() {
            self.setup()
        }
    }
    
    func acceptSetup() {
        globalObject.isActive = true;
        setupInProgress = false
        globalObject.storeAppData()
        postAppData()
    }
    
    func rejectSetup() {
        globalObject.schoolName = nil;
        globalObject.storeAppData();
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
        let latitude = location?.latitude ?? 0.0
        let longitude = location?.longitude ?? 0.0
        let url = URL(string: "\(baseURL)/alert/\(wId)/\(latitude)/\(longitude)")!
        
        print(url.absoluteString)
        
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
        Thread.sleep(forTimeInterval: secondsBetweenSetupUpdateRequests)
        URLSession.shared.reset() {
            self.getWatchIdFromServer()
        }
    }
    
    func sendLocationUpdate(_ location: CLLocation) {
        let wId = globalObject.watchId
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let timestamp = location.timestamp
        let url = URL(string: "\(baseURL)/locationUpdate/\(wId)/\(latitude)/\(longitude)/\(timestamp)")!
        
        print(url.absoluteString)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {return }
            guard let response = String(data: data, encoding: .utf8) else {return}
            print (response)
        }
        
        task.resume()
    }
    
    private func checkWatchStatus() {
        print("Checking watch status...")
        
        if setupInProgress {
            self.retryStatusCheck()
            return
        }
        
        let url = URL(string: "\(baseURL)/checkSetupStatus/\(globalObject.watchId)")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in

            guard let data = data else {
                print("Could not get app data...")
                self.retryStatusCheck()
                return
            }
            
            let appData: AppData
            do {
                appData = try JSONDecoder().decode(AppData.self, from: data)
            } catch {
                print("Could not parse server response")
                self.retryStatusCheck()
                return
            }
            
            DispatchQueue.main.async {
                self.globalObject.schoolName = appData.schoolName
                self.globalObject.isActive = appData.isActive
            }
            
            if appData.schoolName == nil || !appData.isActive {
                print("Watch has been deactivated by school!")
                self.initSetupProcess()
            } else {
                self.retryStatusCheck()
            }
        }
        
        task.resume()
    }
    
    private func retryStatusCheck() {
        Thread.sleep(forTimeInterval: secondsBetweenStatusCheck)
        URLSession.shared.reset() {
            self.checkWatchStatus()
        }
    }
}

private struct WatchIdJsonObject: Codable {
    let watchId: String
}
