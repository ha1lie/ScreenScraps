//
//  PopupController.swift
//  ScreenScraps
//
//  Created by Hallie on 8/10/22.
//

import Foundation
import SwiftUI
import UserNotifications

class PopupController {
    public static func sendLocalNotification(withTitle t: String, body: String) {
        let nContent = UNMutableNotificationContent()
        nContent.title = t
        nContent.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: nContent, trigger: trigger)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
            if let error = error {
                print("Notification Registration Error: \(error.localizedDescription)")
            }
        }
        
        UNUserNotificationCenter.current().add(request) { er in
            if er != nil {
                print("Error adding request: \(er.debugDescription)")
            }
        }
    }
}
