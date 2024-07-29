//
//  LectureAlarmView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/22/24.
//

import SwiftUI

struct LectureAlarmView: View {
    var alarmType: Alarm
    @State private var addMode: Bool = false
    @State private var vibrationStatus: Bool = false
    @State private var ringerStatus: Bool = false
    @State private var drowsinessAlerts: Bool = false
    @State private var pressed: Bool = false
    @State private var noAlarmType: Bool = false
    @State private var ringerDetected: Bool = false
    @State private var lectureInProgress: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var manager: HealthManager
    
    
    var gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.teal.opacity(0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    
    var body: some View {
        let borderColor: Color = colorScheme == .dark ? .white: .black
        VStack {
            HStack {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .overlay(
                        gradient
                    .mask(
                        Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                    )
                Text("Lecture Alarm")
                    .font(.system(size: 25))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .overlay(
                        gradient
                    .mask(
                        Text("Lecture Alarm"))
                            .font(.system(size: 25))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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

            
            if lectureInProgress {
                HStack {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                        .onTapGesture {
                            //if you hold down on it, make an animation of the button expanding to show that you're holding on it, like nike run club does when you stop runs
                        }
                        
                    Text("Lecture in Progress...")
                        .padding(.horizontal, 20)
                        .font(.system(size: 20))
                } .frame(width: 350, height: 70)
                    .cornerRadius(5)
                    .overlay(Capsule().stroke(borderColor, lineWidth: 3))
                    .padding(.top, 30)
                    .shadow(radius: 1)
            }
            
            if !addMode && !lectureInProgress{
                Button {
                    withAnimation {
                        addMode = true
                    }
                    
                } label: {
                    Text("Start Lecture")
                    
                }
                .frame(width: 130, height: 45)
                .background(.blue)
                .clipShape(.capsule)
            .foregroundColor(.white)
            .padding(.top, 30)
            }
            
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
                        Text("Start a Lecture?")
                        
                    } .padding(.top, 30)
                    
                    List {
                        Toggle("Turn on Vibration?", isOn: $vibrationStatus)
                        Toggle("Turn on Ringer?", isOn: $ringerStatus)
                        Toggle("Turn on Drowsiness Alerts?", isOn: $drowsinessAlerts)
                        //Picker with sound type
                        // Picker with volume level
                    } .frame(width: 350, height: 150)
                        .listStyle(.plain)
                        .padding(.top, 20)
                    
                    
                    Button {
                        if (!ringerStatus && !vibrationStatus && !drowsinessAlerts) {
                            noAlarmType = true
                        } else if (ringerStatus) {
                            ringerDetected = true
                        } else {
                            startLecture()
                        }
                        
                    } label: {
                        Text("Activate Alarm")
                        
                    }
                    .frame(width: 130, height: 45)
                    .background(.blue)
                    .clipShape(.capsule)
                    .foregroundColor(.white)
                    
                    .alert("You have not selected an alarm sound. We recommend turning on vibration mode for quiet spaces like a lecture.", isPresented: $noAlarmType) {
                        Button("Vibration") {
                            vibrationStatus = true
                            startLecture()
                            noAlarmType = false
                        }
                        Button("Ringer") {
                            ringerStatus = true
                            startLecture()
                            noAlarmType = false
                        }
                    }
                        
                    .alert("Are you sure you want to to turn on your ringer? Press the button to confirm your choice.", isPresented: $ringerDetected) {
                        Button("Yes") {
                            startLecture()
                            ringerDetected = false
                        }
                        
                        Button("Cancel") {
                            ringerDetected = false
                        }
                        
                        //if they confirm, call function startLecture()
                    }
                }
                .frame(width: 360, height: 340)
                .padding(.top, 20)
               
            }
        } .onAppear {
            manager.startHeartRateQuery()
        }
    }
    
    func startLecture() {
        addMode = false
        withAnimation {
            lectureInProgress = true
        }
    }
}

#Preview {
    ContentView()
}
