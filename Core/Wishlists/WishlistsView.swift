import SwiftUI

struct WishlistsView: View {
    @ObservedObject var wishlistViewModel = WishlistViewModel()
    
    
    var body: some View {
        NavigationView {
            Group {
                if wishlistViewModel.wishlistItems.isEmpty {
                    EmptyStateView()
                } else {
                    listContent
                }
            }
            .navigationTitle("Wishlists")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                wishlistViewModel.loadWishlistItems()
            }
        }
    }

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(wishlistViewModel.wishlistItems) { item in
                    wishlistItemLink(item)
                }
            }
            .padding(.horizontal)
            .padding(.top, -80)
        }
    }

    private func wishlistItemLink(_ item: WishlistItem) -> some View {
        NavigationLink(destination: ListingDetailView_(listing: item.toListing())) {
            WishlistItemView(item: item)
                .frame(height: 120)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.vertical, 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WishlistItemView: View {
    let item: WishlistItem

    var body: some View {
        HStack(spacing: 20) {
            // Use ListingImageCarouselView here
            ListingImageCarouselView(listing: item.toListing())
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding()
    }
}


struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Your wishlist is empty.")
                .foregroundColor(.gray)
                .font(.title3)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

extension WishlistItem {
    
    func toListing() -> Listing {
        Listing(id: id ?? UUID().uuidString,
                ownerUid: "",
                ownerName: ownerName,
                ownerImageUrl: ownerImageUrl,
                numberofGuests: numberofGuests,
                pricePerActivity: pricePerActivity,
                park: park,
                city: city,
                title: title,
                description: description,
                rating: rating,
                imageURLs: imageURLs,
                features: features,
                amenities: amenities)
    }
}

