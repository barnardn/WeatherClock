//
//  OWMCurrentConditions.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation
import ReactiveSwift

enum OWMFetchResult {
    case success(weather: WeatherConditions)
    case network(error: Error)
    case badData(data: Data?)
}

enum OWMError: Error {
    case unknown
    case missingAppID
    case malformedURL(string: String)
    case network(underlyingError: Error)
    case badOrMissingData(data: Data?)
}

enum OWMFetchRequest {
    
    case currentConditions(zipCode: String)

    func toURLRequest() throws -> URLRequest {
        guard let appid = apiKey() else { throw OWMError.missingAppID }
        
        switch self {
        case .currentConditions(let zip):
            let link = "http://api.openweathermap.org/data/2.5/weather?appid=\(appid)&units=imperial&zip=\(zip)"
            guard let url = URL(string: link) else { throw OWMError.malformedURL(string: link) }
            return URLRequest(url: url)
        }
    }
    
    /// puti in an extension
    private func apiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") else { fatalError() }
        guard let keysDict = NSDictionary.init(contentsOfFile: path) as? [String:String] else { fatalError() }
        return keysDict["CurrentConditionsKey"]
    }
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

    func fetch(weatherRequest: OWMFetchRequest) -> SignalProducer<WeatherConditions, OWMError> {
        return dataProduder(forRequest: weatherRequest).flatMap(.concat, weatherProducer)
    }
    
    private func dataProduder(forRequest request: OWMFetchRequest) -> SignalProducer<Data, OWMError> {
        return SignalProducer{ observer, disposable in
            do {
                let urlRequest = try request.toURLRequest()
                let task = self.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                    if let error = error {
                        observer.send(error: .network(underlyingError: error))
                    }
                    guard let _data = data else {
                        observer.send(error: .badOrMissingData(data: data))
                        return
                    }
                    observer.send(value: _data)
                    observer.sendCompleted()
                })
                task.resume()
            } catch let error as OWMError {
                observer.send(error: error)
            } catch {
                observer.send(error: .unknown)
            }
        }
    }
    
    private func weatherProducer(weatherData data: Data) -> SignalProducer<WeatherConditions, OWMError> {
        return SignalProducer{ observer, disposable in
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherConditions.self, from: data)
                observer.send(value: weather)
                observer.sendCompleted()
            } catch {
                observer.send(error: .badOrMissingData(data: data))
            }
        }
    }
    
    
    
}
