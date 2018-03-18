//
//  RootViewModel.swift
//  WeatherClock
//
//  Created by Norm Barnard on 3/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import AppKit
import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

final class RootViewModel {
    typealias DependencyContainer = ContainsAPIAccessKeys & ContainsPreferences
    
    let dependencies: DependencyContainer
    let router: MainRouter
    
    let quitAction: CocoaAction<NSButton>
    
    init(_ dependencyContainer: DependencyContainer, router _router: MainRouter) {
        dependencies = dependencyContainer
        router = _router
        let _quitAction = Action<(), Void, NoError> {
            return SignalProducer{ observer, _ in
                NSApplication.shared.terminate(nil)
            }
        }
        quitAction = CocoaAction(_quitAction)
    }
    
    func childViewControllers() -> [NSViewController] {
        return [router.clockViewController(), router.weatherViewController()]
    }
    
}
