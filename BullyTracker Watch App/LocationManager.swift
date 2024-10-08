import Foundation
import CoreLocation

// Intializes and configures CoreLocation services, starts location monitoring
class LocationManager: NSObject, CLLocationManagerDelegate {
    var clLocationManager: CLLocationManager
    
    override init() {
        clLocationManager = CLLocationManager()
        super.init()
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            // TODO, configure the app to report no location is present
            break
            
        case .authorizedWhenInUse:
            // What to do here? let the app continue as normal? Does a workout session count as in use anyways?
            break
            
        case .authorizedAlways:
            // highest privlige. IDK if we would need it since we would be in an always on session?
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    // for now Coordinates are returned as strings for testing purposes... once we implement geofencing we'll probably have to change
    // TODO: return the values in appropriate data types
    func getMostRecentLocation() -> String {
        // TODO: Send "unauthorized" if location is not available because of authorization
        guard let location = clLocationManager.location else {
            return "unavailable"
        }
        
        return "\(location.coordinate.latitude)-\(location.coordinate.longitude) (location was at time: \(location.timestamp))"
    }
}
