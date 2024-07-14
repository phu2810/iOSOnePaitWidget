//
//  DoggyFetcher.swift
//  onepait
//
//  Created by Phu on 13/7/24.
//

import Foundation
import UIKit
import UserNotifications

struct Doggy: Decodable {
    let message: URL
    let status: String
}

struct DoggyFetcher {
    
    enum DoggyFetcherError: Error {
        case imageDataCorrupted
    }
    
    /// The path where the cached image located
    private static var cachePath: URL {
        if #available(iOS 16.0, *) {
            return URL.cachesDirectory.appending(path: "doggy.png")
        } else {
            let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            return paths[0].appendingPathComponent("doggy.png")
        }
    }
    
    /// The cached dog image
    static var cachedDoggy: UIImage? {
        guard let imageData = try? Data(contentsOf: cachePath) else {
            return  nil
        }
        return UIImage(data: imageData)
    }

    /// Is cached image currently available
    static var cachedDoggyAvailable: Bool {
        cachedDoggy != nil
    }
    
    /// Call the Dog API and then download and cache the dog image
    static func fetchRandomDoggy() async throws -> UIImage {

        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!

        // Fetch JSON data
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let doggy = try JSONDecoder().decode(Doggy.self, from: data)
        
        // Download image from URL
        let (imageData, _) = try await URLSession.shared.data(from: doggy.message)
        
        guard let image = UIImage(data: imageData) else {
            throw DoggyFetcherError.imageDataCorrupted
        }
        
        // Spawn another task to cache the downloaded image
        Task {
            try? await cache(imageData)
        }
        
        return image
    }
    
    /// Save the dog image locally
    private static func cache(_ imageData: Data) async throws {
        try imageData.write(to: cachePath)
    }
}
