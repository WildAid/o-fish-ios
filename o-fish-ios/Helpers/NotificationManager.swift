//
//  NotificationManager.swift
//  
//  Created on 7/8/20.
//  Copyright © 2020 WildAid. All rights reserved.
//

import UserNotifications

class NotificationManager {

    static let closingNotificationIdentifier = "Notification after closing"
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }

            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func setDelegate(_ delegate: UNUserNotificationCenterDelegate) {
        notificationCenter.delegate = delegate
    }

    func removeAllNotification() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func requestNotificationAfterClosing(hours: Int) {
        let localizedString =   NSLocalizedString("It has been %@ hours after closing the application", comment: "")
        let title = String(format: localizedString, String(hours))
        createNotification(title: title, hours: hours, id: NotificationManager.closingNotificationIdentifier)
    }

    func requestNotificationAfterStartDuty(hours: Int) {
        let localizedString = NSLocalizedString("It has been %@ hours after starting of your duty.", comment: "")
        let title = String(format: localizedString, String(hours))
        createNotification(title: title, hours: hours)
    }

    func removeNotificationWithIdentifier(_ id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func createNotification(title: String, hours: Int, id: String = UUID().uuidString) {
        let secondsInHour = 3600
        let seconds = TimeInterval(hours * secondsInHour)
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = NSLocalizedString("Are you still on duty?", comment: "")
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request)

    }
}
