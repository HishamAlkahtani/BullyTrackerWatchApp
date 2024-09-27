import SwiftUI

struct SOSScreen: View {
    @State var studentName: String = ""

    var body: some View {
        VStack {
            if studentName.count == 0 {
                TextField("Student name:",
                          text: $studentName)
            } else {
                // TODO: Replace button with a whole view that implements WokroutSession + Always On
                Button("SOS"){
                    let url = URL(string: "https://BTProto.pythonanywhere.com/alert/\(studentName)/\(locationManager?.getMostRecentLocation() ?? "unavailable")")!
                    
                    let task = URLSession.shared.dataTask(with: url) {
                        (data, response, error) in
                        guard let data = data else {return }
                        print(String(data: data, encoding: .utf8)!)
                    }
                    
                    task.resume()
                }.tint(.red).transition(.opacity)
            }
        }
        .padding()
    }
}
