//
//  ViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 19/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    let center = UNUserNotificationCenter.current()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestPermissions()
    }

    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { _, _ in
            // YOLO
        }
    }
    
    @IBAction func scheduleSingleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "This is a notification"
        content.body = "It is not threaded but still nice."
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    @IBAction func scheduleThreadedNotifications(_ sender: Any) {
        scheduleThreadedNotification(name: "Jan Kaltoun")
    }
    
    @IBAction func scheduleMoreThreadedNotifications(_ sender: Any) {
        scheduleThreadedNotification(name: "Jan Schwarz")
    }
    
    func scheduleThreadedNotification(name: String) {
        (1...5).forEach { _ in
            let content = UNMutableNotificationContent()
            content.title = "This notification is threaded"
            content.body = "There are many notifications, equally cool."
            content.categoryIdentifier = "alarm"
            content.sound = UNNotificationSound.default
            content.threadIdentifier = name
            content.summaryArgument = name

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
}

