//
//  ListingDetailView_.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 02/04/2024.
//

import SwiftUI

struct ListingDetailView_: View {
    @Environment(\.dismiss) var dismiss
    
    let listing: Listing
    @State private var isBookingViewPresented = false
    
    var body: some View {
        ScrollView {
            VStack {
                ListingImageCarouselView(listing: listing)
                    .frame(height: 350)
                    .padding(.bottom, 16)
                    .padding(.top, -100)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(listing.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text("\(listing.park), \(listing.city)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    HostInfoView(listing: listing)
                        .padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    Text(listing.description)
                        .font(.body)
                        .padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    FeaturesAndAmenitiesView(listing: listing)
                        .padding(.horizontal)
                }
            }
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .overlay(BookingBar(listing: listing, isBookingViewPresented: $isBookingViewPresented), alignment: .bottom)
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        }
    }
}

struct HostInfoView: View {
    let listing: Listing
    
    var body: some View {
        HStack(spacing: 16) {
            Image(listing.ownerImageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Hosted by \(listing.ownerName)")
                    .font(.headline)
                
                Text("Up to \(listing.numberofGuests) guests")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

struct FeaturesAndAmenitiesView: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(listing.features) { feature in
                FeatureView(feature: feature)
            }
            Divider().padding(.vertical)
            
            ForEach(listing.amenities) { amenity in
                AmenityView(amenity: amenity)
            }
        }
    }
}

struct FeatureView: View {
    let feature: ListingFeatures
    
    var body: some View {
        HStack {
            Image(systemName: feature.imageName)
                .foregroundColor(.color2)
            VStack(alignment: .leading) {
                Text(feature.title)
                    .fontWeight(.medium)
                Text(feature.subtitle)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

struct AmenityView: View {
    let amenity: ListingAmenities
    
    var body: some View {
        HStack {
            Image(systemName: amenity.imageName)
                .foregroundColor(.color2)
            Text(amenity.title)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}

struct BookingBar: View {
    let listing: Listing
    @Binding var isBookingViewPresented: Bool
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Ksh \(listing.pricePerActivity) /person")
                        .fontWeight(.bold)
                    Text("Total after taxes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button("Reserve") {
                    isBookingViewPresented = true
                }
                .buttonStyle(PrimaryButtonStyle())
                .sheet(isPresented: $isBookingViewPresented) {
                    BookingView(listing: listing)
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.color3)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
#Preview {
    ListingDetailView_(listing: DeveloperPreview.shared.listings[5])
}

