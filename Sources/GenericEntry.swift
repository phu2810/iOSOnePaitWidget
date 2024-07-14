//
//  GenericEntry.swift
//  iOSOnePaitWidget
//
//  Created by Phu on 14/7/24.
//

import Foundation
import WidgetKit

public struct GenericEntry<T>: TimelineEntry {
    public let date: Date
    public let data: T
    
    public init(date: Date, data: T) {
        self.date = date
        self.data = data
    }
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
