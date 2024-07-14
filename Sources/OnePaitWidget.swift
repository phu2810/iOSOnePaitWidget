//
//  OnePaitWidget.swift
//  iOSOnePaitWidget
//
//  Created by Phu on 14/7/24.
//

import Foundation
import WidgetKit
import SwiftUI

public struct OnePaitTimelineData {
    let success: Bool
    let image: UIImage
}
struct DoggyWidgetView: View {
    
    let entry: GenericEntry<OnePaitTimelineData>
    
    public var body: some View {
        ZStack {
            Image(uiImage: entry.data.image)
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
public class OnePaitWidget: BaseTimelineProvider<OnePaitTimelineData> {
    
    public override func placeholder(in context: Context) -> GenericEntry<OnePaitTimelineData> {
        let sample = ResourcesHelper.loadImageFromResourceBundle(imageName: "sample-doggy")!
        return GenericEntry(date: Date(), data: OnePaitTimelineData(success: true, image: sample))
    }

    public override func getSnapshot(in context: Context, completion: @escaping (GenericEntry<OnePaitTimelineData>) -> ()) {
        var snapShotImage: UIImage
        
        if context.isPreview && !DoggyFetcher.cachedDoggyAvailable {
            snapShotImage = ResourcesHelper.loadImageFromResourceBundle(imageName: "sample-doggy")!
        } else {
            snapShotImage = DoggyFetcher.cachedDoggy!
        }
        
        let entry = GenericEntry(date: Date(), data: OnePaitTimelineData(success: true, image: snapShotImage))
        completion(entry)
    }

    public override func asyncFetchData() async throws -> OnePaitTimelineData {
        let image = try await DoggyFetcher.fetchRandomDoggy()
        return OnePaitTimelineData(success: true, image: image)
    }
    
    public static let kind = "com.SwiftSenpaiDemo.DoggyWidgetView"
    
    public static func getWidgetConfiguration() -> some WidgetConfiguration {
        return (
            StaticConfiguration(
                kind: kind,
                provider: OnePaitWidget()
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



