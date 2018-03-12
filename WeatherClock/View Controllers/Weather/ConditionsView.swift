//
//  ConditionsView.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa

class ConditionsView: NSView {

    @IBOutlet weak private var iconImageView: NSImageView!
    @IBOutlet weak private var conditionsLabel: NSTextField!
    @IBOutlet var view: NSView!
    
    var conditionsText: String? {
        didSet {
            conditionsLabel.stringValue = conditionsText ?? ""
        }
    }

    var iconURL: URL? {
        didSet {
            if let iconURL = iconURL {
                iconImageView.setImage(from: iconURL)
            } else {
                iconImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conditionsText = nil
        let placeholder = NSImage(named: NSImage.Name("icon-weather-placeholder"))
        iconImageView.image = placeholder
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        _init()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _init()
    }
    
    func _init() {
        if Bundle.main.loadNibNamed(NSNib.Name("ConditionsView"), owner: self, topLevelObjects: nil) {
            addSubview(view)
            view.frame = bounds
        }
    }
    
    override func updateConstraints() {
        conditionsLabel.preferredMaxLayoutWidth = conditionsLabel.bounds.width
        super.updateConstraints()
    }
    
}
