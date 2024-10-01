import Foundation

/*
     For now we only need to store watchId. If in the future we need to store more, consider
     defining a Codable struct that holds all the app's data. and change DataStore's code
     accordingly.
 */

// Manages persistent data
class DataStore: ObservableObject {

    private static func getFileUrl() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appending(path: "watchId.data")
    }
    
    static func loadWatchId () throws -> Int {
        let fileURL = try DataStore.getFileUrl()
        guard let data = try? Data(contentsOf: fileURL) else {
            return 0
        }
            
        return Int(String(data: data, encoding: .utf8) ?? "0") ?? 0
    }
    
    static func saveWatchId(_ watchId: Int) throws {
        guard let data = String(watchId).data(using: .utf8) else {
            print("Failed to convert watchId to Data object before saving watchId")
            return
        }
        let outFile = try DataStore.getFileUrl()
        try data.write(to: outFile)
    }
}
