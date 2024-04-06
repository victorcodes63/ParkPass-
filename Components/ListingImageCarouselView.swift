//
//  ListingImageCarouselView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 24/02/2024.
//

import SwiftUI

struct ListingImageCarouselView: View {
    let listing: Listing
    
    var body: some View {
        TabView{
            ForEach(listing.imageURLs, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(.page)
        
    }
}

#Preview {
    ListingImageCarouselView(listing: DeveloperPreview.shared.listings[1])
}
