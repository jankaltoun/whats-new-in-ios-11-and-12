//
//  SiriViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 19/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit

class SiriShortcutsViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        donateActivity()
    }
    
    func donateActivity() {
        let activity = NSUserActivity(activityType: "com.jankaltoun.activity.test")

        activity.title = "Say test"

        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true

        activity.userInfo = ["message": "Important!"]

        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("mytest")

        self.userActivity = activity
    }
}

