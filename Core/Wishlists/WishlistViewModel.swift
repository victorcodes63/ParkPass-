//
//  WishlistsViewModel.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 05/04/2024.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

final class WishlistViewModel: ObservableObject {
    @Published var wishlistItems: [WishlistItem] = []
    private let db = Firestore.firestore()
    private var userID: String? { Auth.auth().currentUser?.uid }
    private let storageKey = "likedListings"
    
    init() {
        loadWishlistItems()
    }
    
    func loadWishlistItems() {
        guard let userID = userID else {
            print("User not logged in")
            return
        }
        
        db.collection("users").document(userID).collection("Wishlist")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self?.wishlistItems = documents.compactMap { document -> WishlistItem? in
                    try? document.data(as: WishlistItem.self)
                }
                // Cache liked listings locally
                self?.cacheLikedListings()
            }
    }
    
    // Load liked listings from local cache
    private func loadCachedLikedListings() -> [WishlistItem] {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            do {
                return try JSONDecoder().decode([WishlistItem].self, from: data)
            } catch {
                print("Error decoding cached liked listings: \(error)")
            }
        }
        return []
    }
    
    // Cache liked listings locally
    private func cacheLikedListings() {
        let encodedData = try? JSONEncoder().encode(wishlistItems)
        UserDefaults.standard.set(encodedData, forKey: storageKey)
    }
    
    // Function to check if a listing is liked locally
    func isItemLiked(_ id: String?) -> Bool {
        guard let id = id else { return false }
        return wishlistItems.contains { $0.id == id } || loadCachedLikedListings().contains { $0.id == id }
    }
    
    
    func likeListing(_ wishlistItem: WishlistItem) async {
        guard let userID = self.userID else { return }
        
        // Check if the item is already liked to prevent duplication.
        let existingDocument = try? await db.collection("users")
            .document(userID)
            .collection("Wishlist")
            .whereField("id", isEqualTo: wishlistItem.id ?? "")
            .getDocuments()
        
        // Only proceed if there are no documents with the same ID.
        guard existingDocument?.documents.isEmpty ?? true else { return }
        
        do {
            _ = try db.collection("users").document(userID).collection("Wishlist").addDocument(from: wishlistItem)
            print("Listing liked and added to wishlist successfully!")
        } catch let error {
            print("Error adding wishlist item: \(error)")
        }
    }
    
    
    func unlikeListing(_ identifier: String) async {
        guard let userID = self.userID else { return }
        
        // Query Firestore to check if a wishlist item with the same title exists.
        let querySnapshot = try? await db.collection("users")
            .document(userID)
            .collection("Wishlist")
            .whereField("title", isEqualTo: identifier) // Use identifier here
            .getDocuments()
        
        // If the querySnapshot contains any documents, it means the item exists in the wishlist.
        guard let documents = querySnapshot?.documents, !documents.isEmpty else {
            print("Item does not exist in the wishlist.")
            return
        }
        
        // Proceed to remove the item from the wishlist since it exists.
        do {
            for document in documents {
                try await db.collection("users")
                    .document(userID)
                    .collection("Wishlist")
                    .document(document.documentID)
                    .delete()
            }
            print("Listing unliked and removed from wishlist successfully!")
        } catch let error {
            print("Error removing wishlist item: \(error)")
        }
    }
}

struct WishlistItem: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var ownerName: String
    var ownerImageUrl: String
    var numberofGuests: Int
    var pricePerActivity: Int
    var park: String
    var city: String
    var title: String
    var description: String
    var rating: Int
    var imageURLs: [String]
    var features: [ListingFeatures]
    var amenities: [ListingAmenities]
    
}
    
enum AuthenticationError: Error {
    case notAuthenticated
}


//MARK: TO improve after presentation
//glitch where item is liked but doesnt reflect on the UI heart fill
