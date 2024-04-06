//
//  SwiftUIView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 25/02/2024.
//

import SwiftUI

struct ActivitySearchView: View {
    @State private var searchQuery = ""
    @EnvironmentObject var viewModel: ExploreViewModel
    @State private var listings = ListingDatabase.listings 
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                listingsView
            }
            .navigationBarTitle("Explore Activities", displayMode: .inline)
        }
    }

    private var searchBar: some View {
        TextField("Search activities...", text: $searchQuery)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }

    private var listingsView: some View {
        List(filteredActivities) { listing in
            NavigationLink(destination: ListingDetailView_(listing: listing)) {
                VStack(alignment: .leading) {
                    Text(listing.title)
                        .fontWeight(.bold)
                    Text(listing.park)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var filteredActivities: [Listing] {
        if searchQuery.isEmpty {
            return listings
        } else {
            return listings.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}
