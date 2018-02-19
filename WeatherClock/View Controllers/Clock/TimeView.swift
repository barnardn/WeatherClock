//
//  TimeView.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa

enum TimeViewType {
    case big, normal
}

class TimeView: NSView {
    
    @IBOutlet weak  var timeLabel: NSTextField!
    @IBOutlet weak  var locationLabel: NSTextField!
    @IBOutlet var view: NSView!
    
    
    var time: String? {
        didSet {
            timeLabel.stringValue = time ?? ""
        }
    }
    
    var location: String? {
        didSet {
            locationLabel.stringValue = location ?? ""
        }
    }
    
    var type: TimeViewType = .normal {
        didSet {
            if type == .big {
                timeLabel.font = NSFont.systemFont(ofSize: 38.0)
            }
        }
    }
    
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
    }

    
}
