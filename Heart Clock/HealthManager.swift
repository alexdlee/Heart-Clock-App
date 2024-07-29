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
    
    @Published var heartRate: Double = 0.0
    private var timer: Timer?
    private var healthStore = HKHealthStore()
    private var heartRateAnchor: HKQueryAnchor?
    
    
    init() {
        let heartRate = HKQuantityType(.heartRate)
        NotificationCenter.default.addObserver(self, selector: #selector(startHeartRateQuery), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let healthTypes: Set = [heartRate]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("Error")
            }
        }
    }
    
    @objc func startHeartRateQuery() {
            // Invalidate any existing timer
            timer?.invalidate()
            
            // Start the timer to fetch data every 5 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
                self?.fetchLatestHeartRateSample()
            }
            
            // Fetch initial data
            fetchLatestHeartRateSample()
        }
        
        private func fetchLatestHeartRateSample() {
            let heartRate = HKQuantityType(.heartRate)
            let predicate = HKQuery.predicateForSamples(withStart: Date(), end: Date())
            let query = HKStatisticsQuery(quantityType: heartRate, quantitySamplePredicate: predicate) { _, result, error in
                guard let quantity = result?.sumQuantity(), error == nil else {
                    print("Error fetching heart rate data")
                    return
                }
                let heartRateValue = quantity.doubleValue(for: .count())
                self.heartRate = heartRateValue
                print(heartRateValue)
            }
            
            healthStore.execute(query)
        }
        
        deinit {
            timer?.invalidate()
        }
}
