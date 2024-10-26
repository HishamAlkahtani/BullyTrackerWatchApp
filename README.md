#  BullyTrackerWatchApp

TODO:

- [X] Connect alert button to backend
- [X] Setup process (tentative):
    - [X] 1) The first time the app is run, it asks the backend server to assign it an id...
    - [X] 2) Store the watchId locally in the watch. The watch should be assigned an ID one time only when the app is first installed.
    - [X] 3) After the watch is assigned an id, it is still not active, it must wait for the school admin to link it to the school and then to a student. until the watch app is activated, it keeps periodically asking the backend if it has been linked yet or not
    - [X] 4) Once setup is complete on the client side of the web-app, the backend should respond with the name of the school that is trying to use the watch. A prompt should be displayed on the watch with the name of the school, if YES is pressed, the watch is now activated.

- [ ] Core Location:
    - [X] Implement core location
    - [X] Make the app send the student's last known location when alert button is pressed
    - [ ] Make the app periodically send student's location for parent monitoring?
    - [ ] Force the app to update location when the button is pressed? (Locations can be a few minutes old...)

- [ ] HealthKit:
    - [X] Start HKWorkoutSession (session starts as soon as app opens?)
    - [X] Implement HKLiveWorkoutBuilderDelegate
    - [X] Implement heart rate monitoring
    - [ ] Implement high heart rate auto detection algorithm
    - [ ] Implement Always On (so the screen doesn't lock)
    - [ ] Make the workout session properly end when the app is force closed (there is a bug where the green heart rate sensors remain active even after the app has been force closed)
       
- [ ] User Interfacecs:
    - [X] Make a cancel alert view with a countdown that allows students a chance to cancel the alert (will be used for both the SOS button and the auto detection)
    - [ ] Alert successfully sent view
    - [ ] On start, make the app check if it has a connection to the backend, if not, show an error message

- [ ] Some debugging system to collect data from all watches and send it to a central log file in backend?
- [X] Add an initial view that shows loading sign, waiting to connect to server on the first run of the program
- [ ] Rewrite DataStore to allow storage of info essential to the setup process
- [ ] BUG: If the first request to get watchId from server fails, all subsequent requests fail for some reason. Shouldn't be a problem if you manage to keep the server up and available at all times. But say the watch wasn't connected to the internet on the first attempt, the app is locked out and must be downloaded again...
