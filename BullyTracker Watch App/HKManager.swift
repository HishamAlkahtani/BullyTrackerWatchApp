import Foundation
import HealthKit

// Sets up and initializes and handles all functionalities related to HealthKit
class HKManager: NSObject, ObservableObject, HKLiveWorkoutBuilderDelegate {
    var active: Bool
    let healthStore: HKHealthStore!
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    var globalObject: GlobalObject!
    var alertManager: AlertManager?
    
    // max number of heart rate samples recorded at any time
    private let sampleSize = 10
    private var heartRateSampleQueue: [HKQuantity]

    // num of samples before another alarm can be triggered
    // this is to prevent repititve alerts
    private let cooldownBetweenAlerts = 20
    
    private var sampleNumber = 0
    private var sampleNumberOfLastAlert = -1
    
    
    override init() {
        print("Health Kit Manager!")
        self.active = false
        self.heartRateSampleQueue = []
        if !HKHealthStore.isHealthDataAvailable() {
            print("Health Kit Not Available On The Device")
            self.healthStore = nil
            super.init()
            return
        }
        
        self.healthStore = HKHealthStore()
        
        let neededTypes: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType(.heartRate)
        ]
        
        super.init()
        
        healthStore.requestAuthorization(toShare: neededTypes,
                                         read: neededTypes) {
            (success, error) in
            if success {
                self.active = true
                print("Sucessfully Recieved HealthKit authorization")
                self.startWorkoutSession()
            } else {
                print("HealthKit Authorization Request Failed")
            }
        }
    }
    
    func startWorkoutSession() {
        let config = HKWorkoutConfiguration()
        config.activityType = .cycling
        config.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            builder = session.associatedWorkoutBuilder()
        } catch {
            print("Failed to create HKWorkoutSession: Config Invalid!")
            return
        }
        
        // is this necessary? I think this only stores data to healthStore we might not need that
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore
                                                     , workoutConfiguration: config)
        
        builder.delegate = self
        
        
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) {
            (success, error) in
            guard success else {
                print ("Failed to start HKWorkoutSession")
                return
            }
            print("WorkoutSession Started Sucessfully")
        }
    }
    
    private func checkHeartRateSpikes() {
        if (sampleNumberOfLastAlert != -1 && sampleNumber - sampleNumberOfLastAlert < cooldownBetweenAlerts) {
            return
        }
            
            
        let firstHalfCount = heartRateSampleQueue.count / 2
        let secondHalfCOunt = heartRateSampleQueue.count - firstHalfCount
        var firstHalfSum = 0.0
        var secondHalfSum = 0.0
        
        for number in heartRateSampleQueue.dropLast(secondHalfCOunt) {
            firstHalfSum += number.doubleValue(for: HKUnit(from: "count/min"))
        }
        
        let firstHalfAverage = firstHalfSum / Double(firstHalfCount)
        
        for number in heartRateSampleQueue.dropFirst(firstHalfCount) {
            secondHalfSum += number.doubleValue(for: HKUnit(from: "count/min"))
        }
        
        let secondHalfAverage = secondHalfSum / Double(secondHalfCOunt)
        
        let percentChange = (secondHalfAverage - firstHalfAverage) / firstHalfAverage * 100
        print("Percent Change: \(percentChange)")
        
        if (percentChange > 30) {
            sampleNumberOfLastAlert = sampleNumber
            DispatchQueue.main.async {
                self.alertManager?.startCountdown()
            }
        }
    }
     
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        // App is only authorized to read heart rate, so safe to assume any data coming is HeartRate?
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            
            sampleNumber += 1
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            let heartRate = statistics!.mostRecentQuantity()!
            
            print ("Heart Rate: \(heartRate) \(Date())")
            
            heartRateSampleQueue.append(heartRate)

            if heartRateSampleQueue.count > sampleSize {
                heartRateSampleQueue.remove(at: 0)
                self.checkHeartRateSpikes()
            }

            DispatchQueue.main.async {
                let HR = String(format: "%.2f", statistics?.mostRecentQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? -1.0)
                self.globalObject.heartRate = "\(HR) BPM"
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Required by HKLiveWorkoutBuilderDelegate
        // we don't need to do anything with this
    }
}
