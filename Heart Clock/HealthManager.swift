//
//  HealthManager.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/26/24.
//

import Foundation
import HealthKit
import UIKit
import UserNotifications

class HealthManager: ObservableObject {
    
    @Published var heartRate: Int = 0
    let updateInterval: TimeInterval = 240
    let checkInterval: TimeInterval = 600
    private var timer: Timer?
    private var healthStore = HKHealthStore()
    private var heartRateAnchor: HKQueryAnchor?
    
    
    init() {
        let heartRate = HKQuantityType(.heartRate)
        let healthTypes: Set = [heartRate]
        
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error  in
            if success {
                self.scheduleNextQuery()
            } else {
                print("Error")
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Success")
            } else {
                print("Error requesting notifications")
            }
        }
        
    }
    
    func scheduleNextQuery() {
        
        self.fetchLatestHeartRateSample()
            
        DispatchQueue.main.asyncAfter(deadline: .now() + updateInterval) {
            self.scheduleNextQuery()
        }
        
    }
        
    private func fetchLatestHeartRateSample() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
            
        let predicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-checkInterval), end: Date())
            
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .mostRecent) { _, result, error in
            
            if let error = error {
                print("Error fetching heart rate data: \(error.localizedDescription)")
                return
            }
                
            guard let quantity = result?.mostRecentQuantity() else {
                print("No heart rate data available in the given time frame.")
                return
            }
            
            let heartRateValue = quantity.doubleValue(for: HKUnit(from: "count/min"))
            self.heartRate = Int(heartRateValue)
            print("Most recent heart rate over the last 600 seconds: \(heartRateValue) bpm")
            
            if self.heartRate < 100 {
                self.triggerAlarmNotification()
                
            }
        }
        
        healthStore.execute(query)
    }
    
    func triggerAlarmNotification() {
        print("Hi")
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Wake Up!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    // Need to handle checking the accelerometer data. Also need to handle checking whether those values are low enough to constitute determining the user as asleep.
    
    // Need to understand why the alarm is trigged 3 (2 extra) times in the very beginning, and also change the sound of the alarm, and also make sure that the alarm can trigger while the app is in use, and also trigger the alarm only when the heart rate is low enough.
    
    // Maybe figure out what all the code you don't understand does and write it down in some notes/documents.
    
}
