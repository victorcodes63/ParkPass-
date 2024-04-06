//
//  MainTabView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 23/02/2024.
//

import SwiftUI
import FirebaseStorage


struct MainTabView: View {
    @Binding var showSignInView: Bool
    
   
//  let storage = Storage.storage()
    
    
    var body: some View {
        TabView {
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Explore")
            }
            NavigationStack {
                WishlistsView()
            }
            .tabItem {
                Image(systemName: "heart")
                Text("Wishlists")
            }
            NavigationStack {
                Reservations()
            }
            .tabItem {
                Image(systemName: "gym.bag.fill")
                Text("Reservations")
            }
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
        .accentColor(.color2)
    }
}

#Preview {
    MainTabView(showSignInView: .constant(false))
}

