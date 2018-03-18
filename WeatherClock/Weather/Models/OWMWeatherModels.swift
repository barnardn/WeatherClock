//
//  OWMWeatherModels.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation

enum CompassDirection: String {
    case north = "N"
    case northeast = "NE"
    case east = "E"
    case southeast = "SE"
    case south = "S"
    case southwest = "SW"
    case west = "W"
    case northwest = "NW"
    
    static func approximageDirection(degrees: Double) -> CompassDirection {
        switch degrees {
        case 0...30:
            return .north
        case 31...60:
            return .northeast
        case 61...120:
            return .east
        case 121...150:
            return .southeast
        case 151...210:
            return .south
        case 211...240:
            return .southwest
        case 241...300:
            return .west
        case 301...330:
            return .northwest
        case 331...360:
            return .north
        default:
            return .north
        }
    }
}

extension CompassDirection: CustomStringConvertible {
    var description: String { return self.rawValue }
}


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

struct WindSpeed: Decodable {
    let magnitude: Double
    let direction: Double
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "speed"
        case direction = "deg"
    }
    
    func compassDirection() -> CompassDirection {
        return CompassDirection.approximageDirection(degrees: direction)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        magnitude = try container.decode(Double.self, forKey: .magnitude)
        direction = try container.decode(Double.self, forKey: .direction)
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
    let windSpeed: WindSpeed
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case wind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Temperature.self, forKey: CodingKeys.main)
        parameters = try container.decode([Parameter].self, forKey: CodingKeys.weather)
        windSpeed = try container.decode(WindSpeed.self, forKey: CodingKeys.wind)
    }
    
}

