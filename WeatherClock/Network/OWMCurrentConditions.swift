//
//  OWMCurrentConditions.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/19/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation
import ReactiveSwift

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
    
    private func apiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") else { fatalError() }
        guard let keysDict = NSDictionary.init(contentsOfFile: path) as? [String:String] else { fatalError() }
        return keysDict["CurrentConditionsKey"]
    }
}

class OWMCurrentConditions {
    
    private let urlSession: URLSession
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.timeoutIntervalForResource = 30.0
        urlSession = URLSession(configuration: sessionConfiguration)
    }

    func fetch(weatherRequest: OWMFetchRequest) -> SignalProducer<WeatherConditions, OWMError> {
        return dataProducer(forRequest: weatherRequest).flatMap(.concat, weatherProducer)
    }
    
    private func dataProducer(forRequest request: OWMFetchRequest) -> SignalProducer<Data, OWMError> {
        return SignalProducer{ [weak self] observer, disposable in
            guard let `self` = self else { return }
            do {
                let urlRequest = try request.toURLRequest()
                let task = self.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                    if let error = error {
                        observer.send(error: .network(underlyingError: error))
                        return
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
