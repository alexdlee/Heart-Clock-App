//
//  ContentView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/13/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: HealthManager
    
    var activeAlarm: [Alarm] {
        alarms.filter {$0.activationStatus == true}
    }
    
    var inactiveAlarms: [Alarm] {
        alarms.filter {$0.activationStatus == false }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Alarm Clocks")
                    .font(.system(size: 25))
                
                Section {
                    Text("Active Alarms")
                        .padding(.top, 10)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    List (activeAlarm){ alarm in
                        
                        NavigationLink (destination: DetailedAlarmView(alarmType: alarm)) {
                            VStack {
                                HStack{
                                    Text(alarm.type)
                                    Spacer()
                                    Image(systemName: alarm.imageName)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Text("Inactive Alarms")
                        .padding(.top, 10)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    List(inactiveAlarms) { alarm in
                        NavigationLink(destination: DetailedAlarmView(alarmType: alarm)) {
                            VStack {
                                HStack {
                                    Text(alarm.type)
                                    Spacer()
                                    Image(systemName: alarm.imageName)
                
                                }
                                Button {
                                    alarm.activationStatus = true
                                }
                                label: {
                                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                                }
                                
                            }
                        }
                    }
                }
                    
                Spacer()
            }
        }
        .padding()
        
    }
}
                                        
struct DetailedAlarmView: View {
    var alarmType: Alarm
    @State private var time = Date()
    @State private var vibrationStatus: Bool = false
    @State private var ringerStatus: Bool = false
    @State private var pressed: Bool = false
    
    var body: some View {
        VStack {
            Text("Your " + alarmType.type + " Alarm")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            if alarmType.type == "Sleep" {
                Text("Ready to Set an Alarm?")
                    .padding(.top, 30)
                
                VStack {
                    HStack {
                        Spacer()
                        DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.wheel)
                        
                        Spacer()
                    }
                }
                
            }
            
            List {
                Toggle("Turn on Vibration?", isOn: $vibrationStatus)
                Toggle("Turn on Ringer?", isOn: $ringerStatus)
                //Picker with sound type
                // Picker with volume level
            }
            
            Button {
                activateAlarm()
            
            } label: {
                Text("Activate Alarm")
                
            }
            .frame(width: 130, height: 45)
            .background(.blue)
            .clipShape(.capsule)
            .foregroundColor(.white)
            
            
            if (!vibrationStatus && !ringerStatus && pressed) {
                Text("You have not selected an alarm sound. Please select vibration or ringer!")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()
            
        }
    }
    
    func activateAlarm() {
        pressed = true
        if (!vibrationStatus && !ringerStatus && pressed) {
            return
        } else {
            alarmType.activationStatus = true
        }
    }
                            
}

#Preview {
    ContentView()
}
