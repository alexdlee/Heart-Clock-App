//
//  HealthManager.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/13/24.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    init() {
        let heartRate = HKQuantityType(.heartRate)
        
        let healthTypes: Set = [heartRate]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("error fetching health data")
            }
        }
    }
}
