//
//  HealthManager.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/26/24.
//

import Foundation
import HealthKit
import UIKit

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
        }
        
        healthStore.execute(query)
    }
    
    // Need to handle checking the accelerometer data. Also need to handle checking whether those values are low enough to constitute determining the user as asleep.
    
}
