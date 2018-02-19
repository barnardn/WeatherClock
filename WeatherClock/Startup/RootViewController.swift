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

    private var clockViewController: ClockViewController?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("RootView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _clockViewController = ClockViewController()
        addChildViewController(_clockViewController)
        view.addSubview(_clockViewController.view)
        clockViewController = _clockViewController
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        clockViewController?.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width/2.0, height: view.bounds.height)
    }
    
    @IBAction func quitButtonClicked(_ sender: NSButton) {
        NSApplication.shared.terminate(nil)
    }
}
