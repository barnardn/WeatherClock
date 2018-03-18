//
//  WeatherViewModel.swift
//  WeatherClock
//
//  Created by Norm Barnard on 3/17/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

final class WeatherViewModel {
    
    private let currentConditionsClient: OWMCurrentConditions
    private let disposable = ScopedDisposable(CompositeDisposable())
    
    // MARK: observerable properties
    let weather = MutableProperty<WeatherConditions?>(nil)
    let temperature: Property<Double>
    let conditions: Property<String>
    let windSpeed: Property<String>
    let windDirection: Property<Double>
    let iconURL: Property<URL?>
    
    init(dependencyContainer: ContainsAPIAccessKeys) {
        
        switch dependencyContainer.openWeatherMapAPIKey {
            case .success(let key):
                currentConditionsClient = OWMCurrentConditions(apiKey: key)
            case .failure(let error):
                switch error {
                case .missingConfigurationKey(let keyName):
                    fatalError("Missing \(keyName) keys file")
                case .missingOrCorruptResource(let filename):
                    fatalError("Bad or missig key file: \(filename)")
            }
        }
        
        temperature = weather.map{ $0?.temp.value ?? 0.0 }
        conditions = weather.map{ $0?.parameters.map{ $0.description }.joined(separator: ",") ?? "" }
        windSpeed = weather.map{ weather in
            guard let weather = weather else { return "" }
            return String(format: "\(weather.windSpeed.compassDirection()) at %.1f mph", weather.windSpeed.magnitude)
        }
        windDirection = weather.map{ $0?.windSpeed.direction ?? 0.0 }
        iconURL = weather.map{
            guard let param = $0?.parameters.first else { return nil }
            return URL(string: "http://openweathermap.org/img/w/\(param.iconName).png")
        }
    }
    
    public func refreshWeatherConditions() {
        disposable += currentConditionsClient
            .fetch(weatherRequest: .currentConditions(zipCode: "49002"))
            .on(value: { conditions in
                self.weather.value = conditions
            })
            .start()
    }
    
}

