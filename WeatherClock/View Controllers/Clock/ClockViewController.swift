//
//  ClockViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa

class ClockViewController: NSViewController {

    @IBOutlet weak var localTimeView: TimeView!
    @IBOutlet weak var sanfranTimeView: TimeView!
    @IBOutlet weak var utcTimeView: TimeView!
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ClockView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localTimeView.location = "Local time"
        localTimeView.type = .big
        sanfranTimeView.location = "San Francisco"
        utcTimeView.location = "UTC"
        localTimeView.time = timeAt(timeZone: TimeZone.autoupdatingCurrent)
        sanfranTimeView.time = timeAt(timeZone: TimeZone(abbreviation: "PDT"))
        utcTimeView.time = timeAt(timeZone: TimeZone(abbreviation: "UTC"))
    }
    
    private func timeAt(timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date())
    }
    
    @IBAction func click(_ sender: Any) {
        print("crap")
    }
    
    
}
