//
//  OWMCurrentConditions.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation

enum OWMFetchResult {
    case success(weather: WeatherConditions)
    case network(error: Error)
    case badData(data: Data?)
}

typealias WeatherResultsBlock = (OWMFetchResult) -> Void

class OWMCurrentConditions {
    
    enum Constants {
        static let apiPath = "http://api.openweathermap.org/data/2.5/weather"
        static let appidKey = "appid"
        static let zip = "zip"
        static let imperialUnits = "units=imperial"
    }
    
    private let apiKey: String
    private let urlSession: URLSession
    private var task: URLSessionDataTask?
    
    init(apiKey _apiKey: String) {
        apiKey = _apiKey
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.timeoutIntervalForResource = 30.0
        urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    func fetch(forZipcode zipCode: String, handler: @escaping WeatherResultsBlock) {
        let apiLink = "\(Constants.apiPath)?\(Constants.appidKey)=\(apiKey)&\(Constants.zip)=\(zipCode)&\(Constants.imperialUnits)"
        guard let url = URL(string: apiLink) else { fatalError() }
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                handler(.network(error: error))
                return
            }
            guard let data = data else {
                handler(.badData(data: nil))
                return
            }
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherConditions.self, from: data)
                handler(.success(weather: weather))
            } catch  {
                handler(.badData(data: data))
            }
        }
        task.resume()
    }

    
}
