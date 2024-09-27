import SwiftUI

struct SOSScreen: View {
    @EnvironmentObject var globalObject: GlobalObject
    
    var body: some View {
        VStack {
            Text("\(globalObject.watchId)").foregroundStyle(.gray).padding()
            Button("SOS"){
                sendAlert()
            }.tint(.red).transition(.opacity).padding()
        }.padding()
    }
    
    func sendAlert() {
        let url = URL(string: "https://BTProto.pythonanywhere.com/alert/\(globalObject.watchId)/\(globalObject.locationManager.getMostRecentLocation())")!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
}
    
    

