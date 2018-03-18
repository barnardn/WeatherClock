//
//  TimeView.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import ReactiveSwift

class TimeView: NSView {
    
    @IBOutlet weak  var timeLabel: NSTextField!
    @IBOutlet weak  var locationLabel: NSTextField!
    @IBOutlet var view: NSView!

    public let time = MutableProperty("")
    public let location = MutableProperty("")
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        _init()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _init()
    }
    

    private func _init() {
        if Bundle.main.loadNibNamed(NSNib.Name("TimeView"), owner: self, topLevelObjects: nil) {
            addSubview(view)
            view.frame = bounds
        }
        timeLabel.reactive.stringValue <~ time.producer.observe(on: UIScheduler())
        locationLabel.reactive.stringValue <~ location.producer.observe(on: UIScheduler())
    }

    
}
