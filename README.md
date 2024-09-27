#  BullyTrackerWatchApp

TODO:

- [X] Connect alert button to backend
- [ ] Core Location
    - [X] Implement core location
    - [X] Make the app send the student's last known location when alert button is pressed
    - [ ] Make the app periodically send student's location for parent monitoring?
    - [ ] Force the app to update location when the button is pressed? (Locations can be a few minutes old...)
- [ ] HealthKit
    - [ ] Implement HKWorkoutSession (session starts as soon as app opens?)
    - [ ] Implement heart rate monitoring
    - [ ] Implement high heart rate auto detection algorithm
    - [ ] Implement Always On (so the screen doesn't lock)
- [ ] Make a cancel alert view with a countdown that allows students a chance to cancel the alert (will be used for both the SOS button and the auto detection)
- [ ] Figure out the setup process (Who configures the watch and assigns it to students?)
    - [X] Possible setup process?: When the app opens, the app asks the backend to assign it an ID. This will have the benefit of the id's being shorter (as opposed to randomly generating IDs), since it can just be a counter that we increment. The ID assigned to the watch is then linked to the student by the school's administrator, but the watch app only knows the ID.
- [ ] On start, make the app check if it has a connection to the backend, if not, show an error message
