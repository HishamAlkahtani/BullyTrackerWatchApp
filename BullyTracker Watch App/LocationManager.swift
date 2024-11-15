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
    
    func getMostRecentLocation() -> CLLocationCoordinate2D? {
        guard let location = clLocationManager.location else {
            return nil
        }
        
        return location.coordinate
    }
}
