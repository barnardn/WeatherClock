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
    private var weatherViewController: WeatherViewController?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("RootView")
    }

    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 500.0, height: 200.0)
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _clockViewController = ClockViewController(viewModel: ClockViewModel())
        addChildViewController(_clockViewController)
        view.addSubview(_clockViewController.view)
        clockViewController = _clockViewController
        
        let _weatherViewController = WeatherViewController(withViewModel: WeatherViewModel())
        addChildViewController(_weatherViewController)
        view.addSubview(_weatherViewController.view)
        weatherViewController = _weatherViewController
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        let clockFrame = CGRect(x: 0, y: 0, width: view.bounds.width/2.0, height: view.bounds.height)
        clockViewController?.view.frame = clockFrame
        weatherViewController?.view.frame = CGRect(x: clockFrame.maxX, y: 0, width: clockFrame.width, height: view.bounds.height)
    }
    
    @IBAction func quitButtonClicked(_ sender: NSButton) {
        NSApplication.shared.terminate(nil)
    }
}
