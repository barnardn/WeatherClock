//
//  WeatherViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveSwift
import ReactiveCocoa

class WeatherViewController: NSViewController {

    @IBOutlet weak var conditionsView: ConditionsView!
    @IBOutlet weak var temperatureLabel: NSTextField!
    @IBOutlet weak var directionImageView: NSImageView!
    @IBOutlet weak var windSpeedLabel: NSTextField!
    
    var currentConditions: OWMCurrentConditions?
    var disposeBag = CompositeDisposable()
    
    let viewModel: WeatherViewModel
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("WeatherView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    init(withViewModel _viewModel: WeatherViewModel) {
        viewModel = _viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        temperatureLabel.reactive.stringValue <~ viewModel.temperature.producer
            .observe(on: UIScheduler())
            .map{String(format: "Temperature: %0.f˚", $0)}
        
        conditionsView.iconURLProperty <~ viewModel.iconURL
        conditionsView.conditionsText <~ viewModel.conditions.producer.observe(on: UIScheduler())
        windSpeedLabel.reactive.stringValue <~ viewModel.windSpeed.producer.observe(on: UIScheduler())
        
        viewModel.windDirection.producer
            .observe(on: UIScheduler())
            .on { [weak self] degrees in
                self?.directionImageView.rotate(byDegrees: CGFloat(degrees))
            }.start()
        
        viewModel.refreshWeatherConditions()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        directionImageView.rotate(byDegrees: -1 * directionImageView.boundsRotation)
    }

}
