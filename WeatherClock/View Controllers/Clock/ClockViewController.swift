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
    
    private var cachedDateFormatters = [String: DateFormatter]()
    private var timer: Timer?
    
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
        sanfranTimeView.location = "San Francisco"
        utcTimeView.location = "UTC"
        updateTimeDisplay()
        let _timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let `self` = self else { return }
            self.updateTimeDisplay()
        }
        timer = _timer
        RunLoop.current.add(_timer, forMode: .defaultRunLoopMode)
    }
    
    private func updateTimeDisplay() {
        localTimeView.time = timeAt(timeZone: TimeZone.autoupdatingCurrent)
        sanfranTimeView.time = timeAt(timeZone: TimeZone(abbreviation: "PDT"))
        utcTimeView.time = timeAt(timeZone: TimeZone(abbreviation: "UTC"))
    }
    
    private func timeAt(timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        
        let formatter: DateFormatter
        if let abbrev = timeZone.abbreviation() {
            if let _formatter = cachedDateFormatters[abbrev] {
                formatter = _formatter
            } else {
                formatter = ClockViewController.dateFormatter(forTimeZone: timeZone)
                cachedDateFormatters[abbrev] = formatter
            }
        } else {
            formatter = ClockViewController.dateFormatter(forTimeZone: timeZone)
        }
        return formatter.string(from: Date())
    }
    
    fileprivate static func dateFormatter(forTimeZone timeZone: TimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.timeStyle = .medium
        return formatter
    }
    
}
