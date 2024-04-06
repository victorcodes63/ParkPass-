//
//  ListingsManager.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 14/03/2024.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class ListingsManager: ObservableObject {
    private var listingsListener: ListenerRegistration?
    private var hasUploadedListings = true
    
    static let shared = ListingsManager()
    
    private let storage = Storage.storage()
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    @Published var listings: [Listing] = []

    init() {
        loadData()
    }

    func loadData() {
        listenerRegistration?.remove()
        listenerRegistration = db.collection("listings").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            DispatchQueue.main.async {
                self.listings = documents.compactMap { queryDocumentSnapshot -> Listing? in
                    try? queryDocumentSnapshot.data(as: Listing.self)
                }
            }
        }
    }

    deinit {
        listenerRegistration?.remove()
    }
   
    
    func uploadListings(_ listings: [Listing]) async throws {
        guard !hasUploadedListings else {
            print("Listings already uploaded. Skipping...")
            return
        }
        
        let listingsCollection = db.collection("Listings")
        
        for var listing in listings {
            let imageURLs = try await uploadListingImages(listing: listing)
            listing.imageURLs = imageURLs
            
            // Convert Listing to a dictionary
            let listingData: [String: Any] = [
                "id": listing.id,
                "ownerUid": listing.ownerUid,
                "ownerName": listing.ownerName,
                "ownerImageUrl": listing.ownerImageUrl,
                "numberofGuests": listing.numberofGuests,
                "pricePerActivity": listing.pricePerActivity,
                "park": listing.park,
                "city": listing.city,
                "title": listing.title,
                "description": listing.description,
                "rating": listing.rating,
                "imageURLs": listing.imageURLs,
                "features": listing.features.map { $0.rawValue },
                "amenities": listing.amenities.map { $0.rawValue }
            ]
            
            // Write the listing data to Firestore
            try await listingsCollection.addDocument(data: listingData)
        }
        
        hasUploadedListings = true
        print("Listings uploaded successfully!")
    }
    
    public func fetchListings() async {
        do {
            let querySnapshot = try await db.collection("Listings").getDocuments()
            let fetchedListings = querySnapshot.documents.compactMap { document in
                do {
                    return try document.data(as: Listing.self)
                } catch let error {
                    print("Error decoding listing: \(error.localizedDescription)")
                    return nil
                }
            }
            
            
            let newlistings = fetchedListings.filter { newListing in
                !listings.contains { existingListing in
                    
                    newListing.id == existingListing.id
                }
            }
            listings.append(contentsOf: newlistings)
        } catch let error {
            print("Error fetching listings: \(error.localizedDescription)")
        }
    }
    
    private func uploadListingImages(listing: Listing) async throws -> [String] {
        var imageURLs: [String] = []
        
        for imageName in listing.imageURLs {
            
            guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: nil) else {
                print("Image not found in Assets: \(imageName)")
                continue
            }
            
            do {
                let imageData = try Data(contentsOf: imageURL)
                let imageRef = storage.reference().child("listings/\(listing.id)/\(imageName)")
                let metadata = StorageMetadata() // Empty metadata object
                
                imageRef.putData(imageData, metadata: metadata)
                let downloadURL = try await imageRef.downloadURL().absoluteString
                imageURLs.append(downloadURL)
            } catch let error {
               
                print("Error uploading image: \(error.localizedDescription)")
                
            }
        }
        
        return imageURLs
    }
}

