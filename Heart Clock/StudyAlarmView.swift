//
//  StudyAlarmView.swift
//  Heart Clock
//
//  Created by Alex Lee on 6/22/24.
//

import SwiftUI

struct StudyAlarmView: View {
    var alarmType: Alarm
    @StateObject var sessions = SavedStudySessions()
    @State private var addMode: Bool = false
    @State private var deleteMode: Bool = false
    @State private var toolBarClicked: Bool = false
    @State private var vibrationStatus: Bool = false
    @State private var ringerStatus: Bool = false
    @State private var breakSuggestions: Bool = false
    @State private var pressed: Bool = false
    @State private var navigateMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var manager: HealthManager
    
    
    var gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.green.opacity(0.5), Color.yellow.opacity(0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
   
    var body: some View {
        let borderColor: Color = colorScheme == .dark ? .white: .black
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Image(systemName: "book.fill")
                            .overlay(
                                gradient
                            .mask(
                                Image(systemName: "book.fill"))
                            )
                        Text("Study Alarm")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .overlay(
                                gradient
                            .mask(
                                Text("Study Alarm")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold))
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
                                Text("Start a Study Session?")
                                    
                            } .padding(.top, 30)
                            
                            List {
                                Toggle("Turn on Vibration?", isOn: $vibrationStatus)
                                Toggle("Turn on Ringer?", isOn: $ringerStatus)
                                Toggle("Suggest Breaks?", isOn: $breakSuggestions)
                                //Picker with sound type
                                // Picker with volume level
                            } .frame(width: 350, height: 150)
                                .listStyle(.plain)
                                .padding(.top, 20)
                                
                            
                            Button {
                                saveSessions()
                                addMode = false
                                
                            } label: {
                                Text("Start")
                                
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
                        }
                        .frame(width: 360, height: 340)
                        .padding(.top, 20)
                       
                    }
                    
                    List {
                        Section {
                            ForEach(sessions.savedSessions, id: \.self) { session in
                                Text("Hello")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .font(.system(size:20))
                                                                 
                            }
                            
                            .onDelete { indexSet in
                                sessions.savedSessions.remove(atOffsets: indexSet)
                                
                            }
                        } header: {
                            HStack {
                                EditButton()
                                Spacer ()
                                
                                Text("Saved Sessions")
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
                    .frame(width: 350, height: 200)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 30) {
                        if toolBarClicked {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .transition(.move(edge: .leading))
                                .foregroundColor(.clear)
                                
                                .overlay(
                                    gradient
                                        .mask(
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .transition(.move(edge: .leading))
                                        )
                                )
                                .onTapGesture {
                                    withAnimation{
                                        navigateMode = true
                                    }
                                }
                                .padding(.horizontal, -80)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .transition(.move(edge: .leading))
                                .foregroundColor(.clear)
                                .onTapGesture {
                                    withAnimation {
                                        addMode  = true
                                    }
                                }
                            
                                .overlay(
                                    gradient
                                        .mask(
                                            Image(systemName: "plus")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .transition(.move(edge: .leading))
                                        )
                                )
                             .padding(.horizontal, -80)
                        }
                        
                        HStack {
                            Spacer()
                            Image(systemName: "books.vertical.fill")
                                .resizable()
                                .foregroundColor(.clear)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    gradient
                                .mask(
                                    Image(systemName: "books.vertical.fill")
                                        .resizable()
                                        .frame(width: 35, height: 30)
                                        
                                    )
                                )
                                .onTapGesture {
                                    withAnimation {
                                        toolBarClicked.toggle()
                                    }
                                }
                            
                                .padding(.horizontal, -75)
                                
                        }
                        NavigationLink(destination: StudyAnalytics(), isActive: $navigateMode) {
                            
                        }
                    }
                    
                    
                }
            }
            .onAppear {
                manager.startHeartRateQuery()
            }
        }
    }
    
    func saveSessions() {
        if (!vibrationStatus && !ringerStatus) {
            pressed = true
            return
        } else {
            sessions.savedSessions.append(StudySession())
        }
        
    }
}

struct StudyAnalytics: View {
    var body: some View {
        VStack {
            Text("Study Analytics")
                .font(.system(size: 20))
            
            Spacer()
        }
        
    }
}

#Preview {
    ContentView()
}
