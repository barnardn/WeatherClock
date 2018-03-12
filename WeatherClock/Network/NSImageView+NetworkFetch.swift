//
//  UIImageView+NetworkFetch.swift
//  WeatherClock
//
//  Created by Norm Barnard on 3/11/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import AppKit
import ReactiveSwift

extension NSImageView {

    private enum AssociatedKeys {
        static var sessionKey = "sessionKey"
    }
    
    var urlSession: URLSession {
        get {
            if let session = objc_getAssociatedObject(self, &AssociatedKeys.sessionKey) as? URLSession {
                return session
            }
            let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
            objc_setAssociatedObject(self, &AssociatedKeys.sessionKey, session, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return session
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sessionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setImage(from url: URL)  {
        let task = urlSession.dataTask(with: url) { (imageData, response, error) in
            if let error = error {
                print("Error downloading image \(error)")
                return
            }
            guard let imageData = imageData else {
                DispatchQueue.main.async { self.image = nil }
                return
            }
            DispatchQueue.main.async { self.image = NSImage(data: imageData) }
            
        }
        task.resume()
    }
    
    
}

