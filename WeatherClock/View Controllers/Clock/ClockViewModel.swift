//
//  ClockViewModel.swift
//  WeatherClock
//
//  Created by Norm Barnard on 3/17/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result


final class ClockViewModel {
    
    private var cachedDateFormatters = [String: DateFormatter]()
    private var timer = Timer()
    
    // MARK observable properties
    let localTime = MutableProperty<String>("")
    let alternateTime = MutableProperty<String>("")
    let utcTime = MutableProperty<String>("")
    
    let localTimeLabel = Property(value: "Local Time")
    let alternateTimeLabel = Property(value: "San Francisco")
    let utcTimeLabel = Property(value: "UTC")
    
    init() {
        timer = newTimer()
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
    
    // MARK: private api
    
    private func newTimer() -> Timer {
        let _timer = Timer.init(timeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let `self` = self else { return }
            self.localTime.value = self.timeAt(timeZone: TimeZone.autoupdatingCurrent) ?? ""
            self.alternateTime.value = self.timeAt(timeZone: TimeZone(abbreviation: "PDT")) ?? ""
            self.utcTime.value = self.timeAt(timeZone: TimeZone(abbreviation: "UTC")) ?? ""
        })
        return _timer
    }
        
    private func timeAt(timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        
        let formatter: DateFormatter
        if let abbrev = timeZone.abbreviation() {
            if let _formatter = cachedDateFormatters[abbrev] {
                formatter = _formatter
            } else {
                formatter = ClockViewModel.dateFormatter(forTimeZone: timeZone)
                cachedDateFormatters[abbrev] = formatter
            }
        } else {
            formatter = ClockViewModel.dateFormatter(forTimeZone: timeZone)
        }
        return formatter.string(from: Date())
    }
    
    // MARK: static methods
    
    fileprivate static func dateFormatter(forTimeZone timeZone: TimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.timeStyle = .medium
        return formatter
    }
    
    
}
