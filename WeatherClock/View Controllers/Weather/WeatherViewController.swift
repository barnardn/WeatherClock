//
//  WeatherViewController.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveSwift

class WeatherViewController: NSViewController {

    @IBOutlet weak var conditionsView: ConditionsView!
    @IBOutlet weak var temperatureLabel: NSTextField!
    @IBOutlet weak var directionImageView: NSImageView!
    @IBOutlet weak var windSpeedLabel: NSTextField!
    
    var currentConditions: OWMCurrentConditions?
    var disposeBag = CompositeDisposable()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("WeatherView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentConditions = OWMCurrentConditions()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        disposeBag += currentConditions?.fetch(weatherRequest: .currentConditions(zipCode: "49002"))
            .observe(on: UIScheduler())
            .on(failed: { error in
                print("got error \(error)")
            }, value: { weather in
                self.display(weather)
            })
            .start()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        directionImageView.rotate(byDegrees: -1 * directionImageView.boundsRotation)
    }
    
    
    // MARK: private api

    private func display(_ weather: WeatherConditions) {
        temperatureLabel.stringValue = "Temperature: \(weather.temp.value)˚"
        let conditions = weather.parameters.map{ $0.description }
        conditionsView.conditionsText =  conditions.joined(separator: ",\n")
        windSpeedLabel.stringValue = String(format: "%.1f˚ at %.1f mph", weather.windSpeed.direction,  weather.windSpeed.magnitude)
        directionImageView.rotate(byDegrees: -1 * CGFloat(weather.windSpeed.direction))
        directionImageView.needsDisplay = true
        
        if  let param = weather.parameters.first,
            let iconURL = URL(string: "http://openweathermap.org/img/w/\(param.iconName).png")
        {
            conditionsView.iconURL = iconURL
        } else {
            conditionsView.iconURL = nil
        }
    }

//    private func apiKey() -> String? {
//        guard let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") else { fatalError() }
//        guard let keysDict = NSDictionary.init(contentsOfFile: path) as? [String:String] else { fatalError() }
//        return keysDict["CurrentConditionsKey"]
//    }
//
}
