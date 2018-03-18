//
//  MainRouter.swift
//  WeatherClock
//
//  Created by Norm Barnard on 3/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import AppKit

enum MainRouterAction {
    case preferences
}

typealias RouterTransitionAction = (_ toViewController: NSViewController, _ animated: Bool) -> Void

final class MainRouter {
    typealias ContainerType = ContainsPreferences & ContainsAPIAccessKeys
    
    let dependencyContainer: ContainerType
    
    init(dependencyContainer _dependencyContainer: ContainerType) {
        dependencyContainer = _dependencyContainer
    }
    
    func performTransition(_ transitionAction: RouterTransitionAction, action: MainRouterAction)  {
        /// tbd
        fatalError("Don't call me yet!")
    }
    
    func clockViewController() -> ClockViewController {
        return ClockViewController(viewModel: ClockViewModel())
    }
    
    func weatherViewController() -> WeatherViewController {
        return WeatherViewController(withViewModel: WeatherViewModel(dependencyContainer: dependencyContainer) )
    }
    
    func setupRootViewController() -> NSViewController? {
        return NSViewController()
    }
    
}
