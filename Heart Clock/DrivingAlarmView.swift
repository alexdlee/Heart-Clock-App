//
//  SwiftUIView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/22/24.
//

import SwiftUI

struct DrivingAlarmView: View {
    var alarmType: Alarm
    @State private var addMode: Bool = false
    @State private var vibrationStatus: Bool = false
    @State private var ringerStatus: Bool = false
    @State private var drowsinessAlerts: Bool = false
    @State private var pressed: Bool = false
    @State private var noAlarmType: Bool = false
    @State private var drivingInProgress: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var manager: HealthManager
    
    
    var gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.gray.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    
    var body: some View {
        let borderColor: Color = colorScheme == .dark ? .white: .black
        VStack {
            HStack {
                Image(systemName: "car.fill")
                    .overlay(
                        gradient
                    .mask(
                        Image(systemName: "car.fill"))
                    )
                Text("Driving Alarm")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .overlay(
                        gradient
                    .mask(
                        Text("Driving Alarm"))
                            .font(.system(size: 25))
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
            
            if drivingInProgress {
                HStack {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                        .onTapGesture {
                            //if you hold down on it, make an animation of the button expanding to show that you're holding on it, like nike run club does when you stop runs
                        }
                        
                    Text("Keep Your Eyes on the Road...")
                        .padding(.horizontal, 20)
                        .font(.system(size: 18))
                } .frame(width: 350, height: 70)
                    .overlay(Capsule().stroke(borderColor, lineWidth: 3))
                    .padding(.top, 30)
                    .shadow(radius: 1)
            }
            
            if !addMode && !drivingInProgress{
                Button {
                    withAnimation {
                        addMode = true
                    }
                    
                } label: {
                    Text("Start")
                    
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
                        Text("Going for a Drive?")
                        
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
                        } else {
                            startDriving()
                        }
                        
                    } label: {
                        Text("Activate Alarm")
                        
                    }
                    .frame(width: 130, height: 45)
                    .background(.blue)
                    .clipShape(.capsule)
                    .foregroundColor(.white)
                    
                    .alert("You have not selected an alarm sound. We recommend a loud ringer for driving.", isPresented: $noAlarmType) {
                        Button("Vibration") {
                            vibrationStatus = true
                            startDriving()
                            noAlarmType = false
                        }
                        Button("Ringer") {
                            ringerStatus = true
                            startDriving()
                            noAlarmType = false
                        }
                    }
                }
                .frame(width: 360, height: 340)
                .padding(.top, 20)
               
            }
        } .onAppear {
            manager.scheduleNextQuery()
        }
    }
    
    func startDriving() {
        addMode = false
        withAnimation {
            drivingInProgress = true
        }
    }
}

#Preview {
    ContentView()
}
