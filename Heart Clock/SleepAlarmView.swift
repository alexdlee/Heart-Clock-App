//
//  SleepAlarmView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/22/24.
//

import SwiftUI

struct SleepAlarmView: View {
    @StateObject var saved = SavedAlarms()
    var alarmType: Alarm
    @State private var setTime = Date()
    @State private var vibrationStatus: Bool = false
    @State private var ringerStatus: Bool = false
    @State private var pressed: Bool = false
    @State private var addMode: Bool = false
    @State private var deleteMode: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var manager = HealthManager()
    
    
    var gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    
    var rStatus: String {
        if ringerStatus == false {
            return "Off"
        } else {
            return "On"
        }
    }
    
    var body: some View {
        let borderColor: Color = colorScheme == .dark ? .white: .black
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "moon.zzz.fill")
                        .overlay(
                            gradient
                        .mask(
                            Image(systemName: "moon.zzz.fill"))
                        )
                        Text("Sleep Alarm")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .overlay(
                                gradient
                            .mask(
                                Text("Sleep Alarm"))
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                            )
                                
                }
                
                ZStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.clear)
                        .overlay(
                            gradient
                        .mask(
                            Image(systemName: "heart.fill"))
                        )
                        .padding(.top, 75)
                    Image(systemName: "circle")
                        .resizable()
                        .foregroundColor(.clear)
                        .frame(width: 150, height: 150)
                        .overlay(
                            gradient
                        .mask(
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: 150, height: 150)
                        )
                    )
                    Text("\(manager.heartRate)")
                        .foregroundColor(.clear)
                        .font(.system(size: 50))
                        .padding(.bottom, 10)
                        .overlay(
                            gradient
                        .mask(
                            Text("\(manager.heartRate)")
                                .font(.system(size: 50))
                        )
                    )
                } .padding(.top, 50)
                
                if addMode {
                    VStack {
                        HStack {
                            Text("Close")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    withAnimation {
                                        addMode = false
                                    }
                                }
                                .padding(.horizontal, -80)
                            Text("Ready to Set an Alarm?")
                                
                        } .padding(.top, 30)
                        
                        DatePicker("", selection: $setTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.wheel)
                        
                        List {
                            Toggle("Turn on Vibration?", isOn: $vibrationStatus)
                            Toggle("Turn on Ringer?", isOn: $ringerStatus)
                            //Picker with sound type
                            // Picker with volume level
                        } .frame(width: 350, height: 100)
                            .listStyle(.plain)
                            
                        
                        Button {
                            saveAlarm()
                            
                        } label: {
                            Text("Save Alarm")
                            
                        }
                        .frame(width: 130, height: 45)
                        .background(.blue)
                        .clipShape(.capsule)
                        .foregroundColor(.white)
                        .padding(.bottom, 50)
                        
                        if (!vibrationStatus && !ringerStatus && pressed) {
                            Text("You have not selected an alarm sound. Please select vibration or ringer!")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(width: 360, height: 500)
                    .padding(.top, 20)
                }
            }
            Spacer()

                
            List {
                Section {
                    ForEach(saved.savedAlarms, id: \.self) { alarm in
                        Text(alarm.stringDate)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size:20))
                                                         
                    }
                    
                    .onDelete { indexSet in
                        saved.savedAlarms.remove(atOffsets: indexSet)
                        
                    }
                } header: {
                    HStack {
                        EditButton()
                        Spacer ()
                        
                        Text("Saved Alarms")
                            .multilineTextAlignment(.center)
                        Spacer()
                            
                        Image(systemName: "plus")
                            .onTapGesture {
                                withAnimation {
                                    addMode = true
                                }
                        }
                        
                    }
                }
            }
            .frame(width: 350, height: 500)
            .padding()
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
            .listStyle(.plain)
            .onAppear {
                manager.startHeartRateQuery()
            }
            
        }
    }
    
    func saveAlarm() {
        if (!vibrationStatus && !ringerStatus) {
            pressed = true
            return
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            var savedTime = dateFormatter.string(from: setTime)
            saved.savedAlarms.append(sleepAlarm(time: setTime, ringerMode: true, vibrationMode: ringerStatus, activationStatus: vibrationStatus, stringDate: savedTime))
        }
        
    }
                            
}

#Preview {
    ContentView()
}
