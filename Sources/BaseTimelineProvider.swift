//
//  BaseProvider.swift
//  iOSOnePaitWidget
//
//  Created by Phu on 14/7/24.
//

import Foundation
import WidgetKit

public class BaseTimelineProvider<T>: TimelineProvider {
    
    public init() {}
    
    public func placeholder(in context: Context) -> GenericEntry<T> {
        fatalError("Must override placeholder(in:)")
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (GenericEntry<T>) -> ()) {
        fatalError("Must override getSnapshot(in:completion:)")
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<GenericEntry<T>>) -> ()) {
        Task {
            var data: T = placeholder(in: context).data
            do {
                data = try await asyncFetchData()
            }
            catch {
            }
            let entry = GenericEntry(date: Date(), data: data)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate()))
            completion(timeline)
        }
    }
    
    public func nextUpdateDate() -> Date {
        return Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
    }
    
    public func asyncFetchData() async throws -> T {
        fatalError("Must override asyncFetchData()")
    }
}
