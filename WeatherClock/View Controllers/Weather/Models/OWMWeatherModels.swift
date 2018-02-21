//
//  OWMWeatherModels.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation

struct Temperature: Decodable {
    let value: Double
    let unit = UnitTemperature.fahrenheit
    
    enum CodingKeys: String, CodingKey {
        case value = "temp"
        case unit = "unit"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Double.self, forKey: CodingKeys.value)
    }
    
}

struct Parameter: Decodable {
    let iconName: String
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "main"
        case iconName = "icon"
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? container.decode(String.self, forKey: CodingKeys.name)) ?? ""
        description = (try? container.decode(String.self, forKey: CodingKeys.description)) ?? ""
        iconName = (try? container.decode(String.self, forKey: CodingKeys.iconName)) ?? ""
    }
    
}

struct WeatherConditions: Decodable {
    
    let temp: Temperature
    let parameters: [Parameter]
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Temperature.self, forKey: CodingKeys.main)
        parameters = try container.decode([Parameter].self, forKey: CodingKeys.weather)
    }
    
}

