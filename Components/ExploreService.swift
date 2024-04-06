//
//  ExploreService.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 01/03/2024.
//

import Foundation

class ExploreService {
    func fetchListings() async -> [Listing] {
        // Simulate asynchronous operation, such as fetching data from a server
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                // Simulate fetching data
                let listings = DeveloperPreview.shared.listings
                
                // Complete the continuation with the fetched listings
                continuation.resume(returning: listings)
            }
        }
    }
}


