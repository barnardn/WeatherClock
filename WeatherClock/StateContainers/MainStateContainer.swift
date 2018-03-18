//
//  MainStateContainer.swift
//  WeatherClock
//
//  Created by Norm Barnard on 3/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation
import Result

// storage of user preferences
protocol ContainsPreferences {
    var preferenceSettings: UserDefaults { get }
}

protocol ContainsAPIAccessKeys {
    var openWeatherMapAPIKey: Result<String, DependencyError> { get }
}

// MARK: dependent state error
public enum DependencyError: Error {
    case missingConfigurationKey(keyName: String)
    case missingOrCorruptResource(resourceName: String)
}

final class MainStateContainer: ContainsPreferences {
    
    let preferenceSettings: UserDefaults
    
    init() {
        preferenceSettings = UserDefaults()
    }
}

extension MainStateContainer: ContainsAPIAccessKeys {
    
    var openWeatherMapAPIKey: Result<String, DependencyError> {
        get {
            guard let path = Bundle.main.path(forResource: "apikeys", ofType: "plist")
                else { return .failure(.missingOrCorruptResource(resourceName: "apikeys.plist")) }
            
            guard let keysDict = NSDictionary.init(contentsOfFile: path) as? [String:String]
                else { return .failure(.missingOrCorruptResource(resourceName: "apikeys.plist")) }
            
            guard let apiKey = keysDict["CurrentConditionsKey"]
                else { return .failure(DependencyError.missingConfigurationKey(keyName: "CurrentConditionsKey")) }
            
            return Result.success(apiKey)
        }
    }
    
}
