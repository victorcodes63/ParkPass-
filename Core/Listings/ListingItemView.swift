//
//  ListingItemView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 23/02/2024.
//
import SwiftUI
import FirebaseAuth

struct ListingItemView: View {
    let listing: Listing
    let listingsManager = ListingsManager()
    @ObservedObject var wishlistViewModel = WishlistViewModel()
    
    @State private var isLiked = false
    
    var body: some View {
        VStack(spacing: 0) {
            ListingImageCarouselView(listing: listing)
                .frame(height: 250)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(listing.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("\(listing.park), \(listing.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("KSH \(listing.pricePerActivity)/person")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        toggleWishlistStatus()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(isLiked ? .red : .primary)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(.systemGray).opacity(0.4), radius: 4, x: 0, y: 2)
        .padding()
    }
    
    
   
    private func toggleWishlistStatus() {
        isLiked.toggle()
        
        Task {
            if isLiked {
                
                let newItem = WishlistItem(
                    id: nil,
                    ownerName: listing.ownerName,
                    ownerImageUrl: listing.ownerImageUrl,
                    numberofGuests: listing.numberofGuests,
                    pricePerActivity: listing.pricePerActivity,
                    park: listing.park,
                    city: listing.city,
                    title: listing.title,
                    description: listing.description,
                    rating: listing.rating,
                    imageURLs: listing.imageURLs,
                    features: listing.features,
                    amenities: listing.amenities
                )
                await wishlistViewModel.likeListing(newItem)
            } else {
                let removedItemTitle = listing.title
                await wishlistViewModel.unlikeListing(removedItemTitle)
            }
        }
    }
}



struct ListingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListingItemView(listing: Listing(
            id: "1",
            ownerUid: "1",
            ownerName: "John",
            ownerImageUrl: "driver",
            numberofGuests: 10,
            pricePerActivity: 2000,
            park: "Nairobi National Park",
            city: "Nairobi",
            title: "Park Dash",
            description: "Feel your pulse quicken as you spot iconic wildlife like lions, elephants, and zebras in their natural habitat. Experience the grandeur of the African wilderness from the comfort of an open-air vehicle.",
            rating: 3,
            imageURLs: ["GameDrive1", "GameDrive2", "GameDrive3", "GameDrive4"],
            features: [.bigFiveSighting, .offRoadExperience],
            amenities: [.binoculars, .chargingPorts, .coldDrinks]
        ))
    }
}

