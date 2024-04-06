//
//  ExploreViewModel.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 01/03/2024.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    @Published var listings = [Listing]()
    private let service: ExploreService
    
    init(service: ExploreService) {
        self.service = service
    }
    
    func fetchListings() {
        Task {
            do {
                let fetchedListings = try await service.fetchListings()
                DispatchQueue.main.async {
                    self.listings = fetchedListings
                }
            } catch {
                print("DEBUG: Failed to fetch listings with error: \(error.localizedDescription)")
            }
        }
    }
}
