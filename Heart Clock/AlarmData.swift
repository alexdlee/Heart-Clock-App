//
//  AlarmData.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/13/24.
//

import Foundation

let alarmTypes = ["Sleep", "Studying", "Lecture", "Driving"]

class Alarm: Identifiable {
    var type: String
    var imageName: String
    var activationStatus: Bool
    var vibrationMode: Bool
    var ringerMode: Bool
    
    init(type: String, imageName: String, activationStatus: Bool, vibrationMode: Bool, ringerMode: Bool) {
        self.type = type
        self.imageName = imageName
        self.activationStatus = activationStatus
        self.vibrationMode = vibrationMode
        self.ringerMode = ringerMode
    }
}

var sleepAlarm = Alarm(type: "Sleep", imageName: "bed.double.fill", activationStatus: false, vibrationMode: false, ringerMode: false)
var studyAlarm = Alarm(type: "Studying", imageName: "book.fill", activationStatus: false, vibrationMode: false, ringerMode: false)
var lectureAlarm = Alarm(type: "Lecture", imageName: "rectangle.and.pencil.and.ellipsis", activationStatus: false, vibrationMode: false, ringerMode: false)
var drivingAlarm = Alarm(type: "Driving", imageName: "car.fill", activationStatus: false, vibrationMode: false, ringerMode: false)

var alarms = [sleepAlarm, studyAlarm, lectureAlarm, drivingAlarm]


