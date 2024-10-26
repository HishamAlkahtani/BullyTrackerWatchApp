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
            .appending(path: "appData.json")
    }
    
    static func loadAppData () throws -> AppData {
        let fileURL = try DataStore.getFileUrl()
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(AppData.self, from: data)
    }
    
    static func saveAppData (_ appData: AppData) throws {
        let data = try JSONEncoder().encode(appData)
        let outFile = try DataStore.getFileUrl()
        try data.write(to: outFile)
    }
}

struct AppData: Codable {
    let watchId: String?
    let isActive: Bool
    let schoolName: String?
}
