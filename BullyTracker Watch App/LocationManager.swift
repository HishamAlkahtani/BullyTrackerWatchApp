import Foundation
import CoreLocation

// Intializes and configures CoreLocation services, starts location monitoring
class LocationManager: NSObject, CLLocationManagerDelegate {
    var clLocationManager: CLLocationManager
    var backendRequests: BackendRequests?
    
    private var timeOfNextUpdate: Date?
    private var minutesBetweenLocationUpdates: Double = 1
    
    override init() {
        clLocationManager = CLLocationManager()
        self.backendRequests = nil
        super.init()
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.distanceFilter = kCLDistanceFilterNone
        clLocationManager.startUpdatingLocation()
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
        print("Location Manager Location Update!")
        let newLocation = locations.last!
        
        // send location update if an update has not been sent before, or if enough time has passed
        if timeOfNextUpdate == nil || newLocation.timestamp.compare(timeOfNextUpdate!) == .orderedDescending {
            timeOfNextUpdate = newLocation.timestamp.addingTimeInterval(60.0 * minutesBetweenLocationUpdates)
            backendRequests?.sendLocationUpdate(newLocation)
        }
    }
    
    func getMostRecentLocation() -> CLLocationCoordinate2D? {
        guard let location = clLocationManager.location else {
            return nil
        }
        
        return location.coordinate
    }
}
