//
//  RootViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController {

    @IBOutlet weak var quoteLabel: NSTextField!
    @IBOutlet weak var quitButton: NSButton!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("RootView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        quoteLabel.stringValue = "\(quoteText) -- \(quoteAuthor)"
    }
    
    @IBAction func quitButtonClicked(_ sender: NSButton) {
        NSApplication.shared.terminate(nil)
    }
}
