#  BullyTrackerWatchApp

TODO:

- [X] Connect alert button to backend
- [ ] Core Location
    - [X] Implement core location
    - [X] Make the app send the student's location when alert button is pressed
    - [ ] Make the app periodically send student's location for parent monitoring?
- [ ] HealthKit
    - [ ] Implement HKWorkoutSession (session starts as soon as app opens?)
    - [ ] Implement heart rate monitoring
    - [ ] Implement high heart rate auto detection algorithm
    - [ ] Implement Always On (so the screen doesn't lock)
- [ ] Make a cancel alert view with a countdown that allows students a chance to cancel the alert (will be used for both the SOS button and the auto detection)
- [ ] Figure out the setup process (Who configures the watch and assigns it to students?)
- [ ] On start, make the app check if it has a connection to the backend, if not, show an error message
