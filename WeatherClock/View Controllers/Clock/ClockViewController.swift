//
//  ClockViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveSwift
import ReactiveCocoa

class ClockViewController: NSViewController {

    private var viewModel: ClockViewModel
    private let disposable = ScopedDisposable(CompositeDisposable())
    
    @IBOutlet weak var localTimeView: TimeView!
    @IBOutlet weak var sanfranTimeView: TimeView!
    @IBOutlet weak var utcTimeView: TimeView!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ClockView")
    }
    
    init(viewModel _viewModel: ClockViewModel) {
        viewModel = _viewModel
        
        
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localTimeView.location = "Local time"
        sanfranTimeView.location = "San Francisco"
        utcTimeView.location = "UTC"
        disposable += localTimeView.timeLabel.reactive.stringValue <~ viewModel.localTime.producer.observe(on: UIScheduler())
        disposable += sanfranTimeView.timeLabel.reactive.stringValue <~ viewModel.sanfranTime.producer.observe(on: UIScheduler())
        disposable += utcTimeView.timeLabel.reactive.stringValue <~ viewModel.utcTime.producer.observe(on: UIScheduler())
    }
    
}
