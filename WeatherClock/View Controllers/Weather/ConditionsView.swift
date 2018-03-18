//
//  ConditionsView.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveSwift
import ReactiveCocoa

class ConditionsView: NSView {

    @IBOutlet weak private var iconImageView: NSImageView!
    @IBOutlet weak private var conditionsLabel: NSTextField!
    @IBOutlet var view: NSView!

    let conditionsText = MutableProperty("")
    let iconURLProperty = MutableProperty<URL?>(nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        conditionsLabel.reactive.stringValue <~ conditionsText.producer.observe(on: UIScheduler())
        iconURLProperty.producer.observe(on: UIScheduler()).on { url in
            if let url = url {
                self.iconImageView.setImage(from: url)
            } else {
                self.iconImageView.image = nil
            }
        }.start()
        
    }
    
    override func updateConstraints() {
        conditionsLabel.preferredMaxLayoutWidth = conditionsLabel.bounds.width
        super.updateConstraints()
    }
    
}
