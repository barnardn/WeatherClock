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
    @IBOutlet weak var directionImageView: NSImageView!
    @IBOutlet weak var windSpeedLabel: NSTextField!
    
    var currentConditions: OWMCurrentConditions?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("WeatherView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let apikey = apiKey() else { fatalError() }
        currentConditions = OWMCurrentConditions(apiKey: apikey)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        guard let currentConditions = currentConditions else { return }
        currentConditions.fetch(forZipcode: "49002") { [weak self] fetchResults in
            DispatchQueue.main.async { self?.display(fetchResults) }
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        directionImageView.rotate(byDegrees: -1 * directionImageView.boundsRotation)
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
            windSpeedLabel.stringValue = String(format: "%.1f˚ at %.1f mph", weather.windSpeed.direction,  weather.windSpeed.magnitude)
            directionImageView.rotate(byDegrees: -1 * CGFloat(weather.windSpeed.direction))
            directionImageView.needsDisplay = true
        }
    }

    private func apiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") else { fatalError() }
        guard let keysDict = NSDictionary.init(contentsOfFile: path) as? [String:String] else { fatalError() }
        return keysDict["CurrentConditionsKey"]
    }
    
}
