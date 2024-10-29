//
//  Notification.swift
//  Hydrate
//
//  Created by Rand Soliman Alobaid on 17/04/1446 AH.
//

import SwiftUI
import UserNotifications

struct Notification: View {
    
    @EnvironmentObject var waterIntakeModel: WaterIntakeModel // Access the shared model
    @State private var selectedTime1 = Date()
    @State private var selectedTime2 = Date()
    @State private var selectedInterval: String? // Track selected interval
    @State private var navigateToWaterIntakeView = false // State variable for navigation

    
    var body: some View {
        VStack {
            
            Text("Notification Preferences")
                .bold()
                .font(.system(size: 22))
                .padding(.trailing, 115)
                .padding(.bottom, 10)
                .padding(.top, 30)
            
            Text("The start and End hour")
                .bold()
                .padding(.trailing, 175)
                .padding(.bottom, 5)
            
            Text("Specify the start and end date to receive the notifications")
                .foregroundColor(Color(hex: "636366"))
                .font(.system(size: 16))
                .padding(.trailing, 40)
                .padding(.leading, 15)
                .padding(.bottom, 15)
            
            Rectangle()
                .fill(Color(hex: "F2F2F7")) // Light gray background
                .frame(width: 360, height: 130)
                .overlay(
                    VStack {
                        DatePicker("Start hour", selection: $selectedTime1, displayedComponents: .hourAndMinute)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .foregroundColor(.black)
                        
                        Divider()
                            .background(Color(hex: "CFCFE0"))
                        
                        DatePicker("End hour", selection: $selectedTime2, displayedComponents: .hourAndMinute)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                )
                .padding(.bottom, 30)
            
            Text("Notification interval")
                .bold()
                .padding(.trailing, 200)
                .padding(.bottom, 5)
            
            Text("How often would you like to receive notifications within the specified time interval")
                .foregroundColor(Color(hex: "636366"))
                .font(.system(size: 16))
                .padding(.trailing, 20)
                .padding(.leading, 20)
                .padding(.bottom, 15)
            
            // First row of buttons
            HStack {
                createIntervalButton(title: "1", subtitle: "Mins")
                createIntervalButton(title: "30", subtitle: "Mins")
                createIntervalButton(title: "60", subtitle: "Mins")
                createIntervalButton(title: "90", subtitle: "Mins")
            }
            
            // Second row of buttons
            HStack {
                createIntervalButton(title: "2", subtitle: "Hours")
                createIntervalButton(title: "3", subtitle: "Hours")
                createIntervalButton(title: "4", subtitle: "Hours")
                createIntervalButton(title: "5", subtitle: "Hours")
            }
            
            Button(action: {
                                scheduleNotifications()
                                navigateToWaterIntakeView = true // Set to true to navigate
                            }) {
                                Text("Start")
                                    .foregroundColor(.white)
                                    .frame(width: 355, height: 55)
                                    .background(Color(hex: "32ADE6"))
                                    .cornerRadius(10)
                            }
                            .padding(.top, 80)
            
            // NavigationLink for WaterIntakeView
                            NavigationLink(destination: WaterIntakeView().environmentObject(waterIntakeModel), isActive: $navigateToWaterIntakeView) {
                                EmptyView() // Hidden link
                            }
            
        }
        .onAppear(perform: requestNotificationPermission) // Request permission on appear
        .navigationBarBackButtonHidden(true)
    }
    
    private func createIntervalButton(title: String, subtitle: String) -> some View {
        Button(action: {
            selectedInterval = "\(title) \(subtitle)" // Set selected interval
        }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(selectedInterval == "\(title) \(subtitle)" ? Color(hex: "32ADE6") : Color(hex: "F2F2F7"))
                .frame(width: 75, height: 75)
                .overlay(
                    VStack {
                        Text(title)
                            .foregroundColor(selectedInterval == "\(title) \(subtitle)" ? .white : Color(hex: "32ADE6"))
                        Text(subtitle)
                            .foregroundColor(selectedInterval == "\(title) \(subtitle)" ? .white : .black)
                    }
                    .multilineTextAlignment(.center)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(6)
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleNotifications() {
        guard let selectedInterval = selectedInterval else { return }

        let intervalInMinutes: Int
        switch selectedInterval {
        case "1 Mins": intervalInMinutes = 1
        case "30 Mins": intervalInMinutes = 30
        case "60 Mins": intervalInMinutes = 60
        case "90 Mins": intervalInMinutes = 90
        case "2 Hours": intervalInMinutes = 120
        case "3 Hours": intervalInMinutes = 180
        case "4 Hours": intervalInMinutes = 240
        case "5 Hours": intervalInMinutes = 300
        default: return
        }

        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime1)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime2)

        guard let startHour = startComponents.hour, let startMinute = startComponents.minute,
              let endHour = endComponents.hour, let endMinute = endComponents.minute else { return }

        let currentDate = Date()
        let calendar = Calendar.current

        // Schedule notifications
        for hour in startHour..<endHour {
            for minute in stride(from: startMinute, to: 60, by: intervalInMinutes) {
                let notificationTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) ?? currentDate
                
                if notificationTime > currentDate {
                    print("Scheduling notification for \(notificationTime)") // Debugging line
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Hydration Reminder"
                    content.body = "Time to drink water!"
                    content.sound = .default
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime.timeIntervalSinceNow, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        } else {
                            // Print confirmation when the notification is successfully scheduled
                            print("Notification scheduled for \(formattedTime(notificationTime))")
                        }
                    }
                }
            }
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    Notification()
        .environmentObject(WaterIntakeModel())
}
