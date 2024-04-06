//
//  ExploreView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 23/02/2024.
//

import SwiftUI

struct ExploreView: View {
    @State private var showActivitySearchView = false
    @StateObject var viewModel = ExploreViewModel(service: ExploreService())
    @StateObject var wishlistViewModel = WishlistViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            SearchAndFilterBar()
                .padding(.top,8)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
                .onTapGesture {
                        showActivitySearchView.toggle()
                }
                .padding(.top, 8)
            
            if showActivitySearchView {
                ActivitySearchView()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.listings) { listing in
                            NavigationLink(destination: ListingDetailView_(listing: listing)) {
                                ListingItemView(listing: listing)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 390)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.fetchListings()
                    wishlistViewModel.loadWishlistItems()
                }
                .zIndex(0)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
}


struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}

