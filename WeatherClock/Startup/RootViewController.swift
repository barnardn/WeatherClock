//
//  RootViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import ReactiveSwift

class RootViewController: NSViewController {

    private var clockViewController: NSViewController?
    private var weatherViewController: NSViewController?
    private var viewModel: RootViewModel
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("RootView")
    }

    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 500.0, height: 200.0)
        }
        set { super.preferredContentSize = newValue }
    }
    
    init(viewModel _viewModel: RootViewModel) {
        viewModel = _viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = viewModel.childViewControllers()
        
        let _clockViewController = viewControllers[0]
        addChildViewController(_clockViewController)
        view.addSubview(_clockViewController.view)
        clockViewController = _clockViewController
        
        let _weatherViewController = viewControllers[1]
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

}
