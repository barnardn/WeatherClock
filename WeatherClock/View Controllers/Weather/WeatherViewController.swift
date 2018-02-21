//
//  WeatherViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa

class WeatherViewController: NSViewController {

    @IBOutlet weak var conditionsView: ConditionsView!
    @IBOutlet weak var temperatureLabel: NSTextField!
    
    let currentConditions = OWMCurrentConditions(apiKey: "75938ca6d68f6f92ec9b55946fb119af")
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("WeatherView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentConditions.fetch(forZipcode: "49002") { [weak self] fetchResults in
            DispatchQueue.main.async { self?.display(fetchResults) }
        }
    }
    
    // MARK: private api

    private func display(_ results: OWMFetchResult) {
        switch results {
        case .badData:
            print("Missing or bad data")
        case .network(let error):
            print(error.localizedDescription)
        case .success(let weather):
            temperatureLabel.stringValue = "Temperature: \(weather.temp.value)˚"
            let conditions = weather.parameters.map{ $0.description }
            conditionsView.conditionsText =  conditions.joined(separator: ",\n")
        }
    }
    
}
