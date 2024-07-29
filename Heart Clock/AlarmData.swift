//
//  AlarmData.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/13/24.
//

import Foundation
import Combine
import SwiftUI

let alarmTypes = ["Sleep", "Studying", "Lecture", "Driving"]

struct Alarm: Identifiable {
    let id = UUID()
    var type: String
    var imageName: String
    var activationStatus: Bool
    var vibrationMode: Bool
    var ringerMode: Bool
    var color: LinearGradient

}

struct sleepAlarm: Identifiable, Codable, Hashable {
    let id = UUID()
    var time: Date
    var ringerMode: Bool
    var vibrationMode: Bool
    // var ringerType: ringer sound
    var activationStatus: Bool
    var stringDate: String
    var items: [String]?
    // var some variable that represents the heart rate at which an alarm should be fired off (determined by user or automatically)
}

struct StudySession: Identifiable, Codable, Hashable {
    let id = UUID()
}

class AlarmViewModel: ObservableObject {
    @Published var alarms: [Alarm] = alarms_list
    
    var inactiveAlarms: [Alarm] {
        alarms.filter {$0.activationStatus == false }
    }
    
    var activeAlarms: [Alarm] {
        alarms.filter {$0.activationStatus == true}
    }
    
    func toggleAlarmStatus(alarmType: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarmType.id }) {
            alarms[index].activationStatus.toggle()
        }
    }
}

var alarms_list = [Alarm(type: "Sleep", imageName: "moon.zzz.fill", activationStatus: false, vibrationMode: false, ringerMode: false, color: LinearGradient(
    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)), Alarm(type: "Studying", imageName: "book.fill", activationStatus: false, vibrationMode: false, ringerMode: false, color:  LinearGradient(
    gradient: Gradient(colors: [Color.green.opacity(0.5), Color.yellow.opacity(0.5)]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)), Alarm(type: "Lecture", imageName: "rectangle.and.pencil.and.ellipsis", activationStatus: false, vibrationMode: false, ringerMode: false, color: LinearGradient(
    gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.teal.opacity(0.5)]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)), Alarm(type: "Driving", imageName: "car.fill", activationStatus: false, vibrationMode: false, ringerMode: false, color: LinearGradient(
    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.gray.opacity(0.3)]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
))]

class SavedStudySessions: ObservableObject {
    
    @Published var savedSessions: [StudySession] = [] {
        didSet {
            saveToUserDefaults() // whenever a new business is added or removed to saved list, saveToUserDefaults() is called
        }
    }

    init() {
        loadFromUserDefaults() // whenever the class is created, loadFromUserDefaults() is called
    }

    private let savedSessionsKey = "Saved Study Sessions" // creating a key that will be used later

    private func saveToUserDefaults() {
        let data = try? JSONEncoder().encode(savedSessions)
        UserDefaults.standard.set(data, forKey: savedSessionsKey)
    }

    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: savedSessionsKey) { // if the data retrieved from UserDefaults.standard using the key savedAlarmsKey exists, then set it equal to data
            if let savedSessions = try? JSONDecoder().decode([StudySession].self, from: data) { // if JSONDecoder can decode the data within the variable data into an object of type [Businesses].self, then store that decoded data into savedBusinesses
                self.savedSessions = savedSessions // set the current list of savedBusinesses to the array of savedBusinesses retrieved by decoding the data found in the UserDefaults.standard storage compartment
            }
        }
    }
    
}

class SavedAlarms: ObservableObject {
    
    // should sort by ascending time
    
    
    @Published var savedAlarms: [sleepAlarm] = [] {
        didSet {
            saveToUserDefaults() // whenever a new business is added or removed to saved list, saveToUserDefaults() is called
        }
    }

    init() {
        loadFromUserDefaults() // whenever the class is created, loadFromUserDefaults() is called
    }

    private let savedAlarmsKey = "Saved Alarms" // creating a key that will be used later

    private func saveToUserDefaults() {
        let data = try? JSONEncoder().encode(savedAlarms)
        UserDefaults.standard.set(data, forKey: savedAlarmsKey)
    }

    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: savedAlarmsKey) { // if the data retrieved from UserDefaults.standard using the key savedAlarmsKey exists, then set it equal to data
            if let savedAlarms = try? JSONDecoder().decode([sleepAlarm].self, from: data) { // if JSONDecoder can decode the data within the variable data into an object of type [Businesses].self, then store that decoded data into savedBusinesses
                self.savedAlarms = savedAlarms // set the current list of savedBusinesses to the array of savedBusinesses retrieved by decoding the data found in the UserDefaults.standard storage compartment
            }
        }
    }
}
