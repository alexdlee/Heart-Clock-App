//
//  AlarmView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = AlarmViewModel()
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Alarm Clocks")
                    .font(.system(size: 25))
                
                    Text("Active Alarms")
                        .padding(.top, 10)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    
                List (viewModel.activeAlarms){ alarm in
                        
                    NavigationLink (destination: destinationNavigator(for: alarm)) {
                            VStack {
                                HStack {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.toggleAlarmStatus(alarmType: alarm)
                                            }
                                        }
                                    Image(systemName: alarm.imageName)
                                    Text(alarm.type)
                                    Spacer()
                                }
                            }
                        }
                        .listRowBackground(alarm.color)
                    }
                
                    Text("Inactive Alarms")
                        .padding(.top, 10)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    
                List(viewModel.inactiveAlarms) { alarm in
                        NavigationLink (destination: destinationNavigator(for: alarm)) {
                            VStack {
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.toggleAlarmStatus(alarmType: alarm)
                                            }
                                        }
                                    Image(systemName: alarm.imageName)
                                    Text(alarm.type)
                                    Spacer()
                                }
                            }
                        }
                        
                        .listRowBackground(alarm.color)
                    }
                    
                Spacer()
            }
        }
        .padding()
        
    }
    func destinationNavigator(for anyAlarm: Alarm) -> some View {
        switch anyAlarm.type {
        case "Sleep":
            return AnyView(SleepAlarmView(alarmType: anyAlarm))
        case "Studying":
            return AnyView(StudyAlarmView(alarmType: anyAlarm))
        case "Lecture":
            return AnyView(LectureAlarmView(alarmType: anyAlarm))
        case "Driving":
            return AnyView(DrivingAlarmView(alarmType: anyAlarm))
        default:
            return AnyView(DrivingAlarmView(alarmType: anyAlarm))
        }
        
    }
    
}

#Preview {
    HomeView()
}
