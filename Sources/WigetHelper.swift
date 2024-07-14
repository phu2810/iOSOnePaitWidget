//
//  WigetHelper.swift
//  onepait
//
//  Created by Phu on 13/7/24.
//

import WidgetKit
import SwiftUI

public struct DoggyEntry: TimelineEntry {
    public let date: Date
    let image: UIImage
}

public struct DoggyWidgetView: View {
    
    let entry: DoggyEntry
    
    public var body: some View {
        ZStack {
            Image(uiImage: entry.image)
                .resizable()
                .scaledToFill()
                .clipped()
            
            Text(entry.dateFormatted)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
                .padding()
        }
    }
}

extension DoggyEntry {
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

public struct DoggyTimelineProvider: TimelineProvider {

    public func placeholder(in context: Context) -> DoggyEntry {
        let sample = UIImage(named: "sample-doggy")!
        return DoggyEntry(date: Date(), image: sample)
    }

    public func getSnapshot(in context: Context, completion: @escaping (DoggyEntry) -> ()) {
        
        var snapshotDoggy: UIImage
        
        if context.isPreview && !DoggyFetcher.cachedDoggyAvailable {
            // Use local sample image as snapshot if cached image not available
            snapshotDoggy = UIImage(named: "sample-doggy")!
        } else {
            // Use cached image as snapshot
            snapshotDoggy = DoggyFetcher.cachedDoggy!
        }
        
        let entry = DoggyEntry(date: Date(), image: snapshotDoggy)
        completion(entry)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<DoggyEntry>) -> ()) {
        
        Task {

            // Fetch a random doggy image from server
            guard let image = try? await DoggyFetcher.fetchRandomDoggy() else {
                return
            }
            
            let entry = DoggyEntry(date: Date(), image: image)
            
            // Next fetch happens 15 minutes later
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 15),
                to: Date()
            )!
            
            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )
            
            completion(timeline)
        }
    }
    
    public static let kind = "com.SwiftSenpaiDemo.DoggyWidgetView"
    
    public static func getWidgetConfiguration() -> some WidgetConfiguration {
        return (
            StaticConfiguration(
                kind: kind,
                provider: DoggyTimelineProvider()
            ) { entry in
                DoggyWidgetView(entry: entry)
            }
            .configurationDisplayName("Doggy Widget")
            .description("Unlimited doggy all day long.")
            .supportedFamilies([
                .systemSmall,
            ])
            .contentMarginsDisabled()
        )
    }
}
