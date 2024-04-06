//
//  ProfileViewModel.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 07/03/2024.
//

import Foundation
import SwiftUI
import Firebase
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var profileImage: UIImage?
    @Published var isLoadingUserData = true

    

    
    private var cancellables = Set<AnyCancellable>()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        Task {
            do {
                // Load current user data first
                try await loadCurrentUser()
                
                // After the user data is successfully loaded, check if there's a profile image URL
                if let imageUrl = self.user?.photoUrl {
                    // Load the profile image from the URL
                    await loadProfileImageFromURL(imageUrl)
                }
            } catch {
                print("Error loading current user or profile image: \(error)")
            }
        }
    }

    func loadCurrentUser() async throws {
        isLoadingUserData = true
        
        guard let currentUser = Auth.auth().currentUser else {
            throw AuthenticationError.notAuthenticated
        }

        // Check if the user signed in with Google
        if let _ = currentUser.providerData.first(where: { $0.providerID == "google.com" }) {
            self.name = currentUser.displayName ?? ""
            self.email = currentUser.email ?? ""
            
            
            if let photoURL = currentUser.photoURL?.absoluteString {
                await loadProfileImageFromURL(photoURL)
            }
        } else {
            self.name = ""
            self.profileImage = nil
        }
        isLoadingUserData = false
    }
    
    func loadProfileImageIfNeeded() async {
        if let urlString = user?.photoUrl, profileImage == nil {
            await loadProfileImageFromURL(urlString)
        }
    }
   
    // Method to load profile image URL for Google sign-in users
    func loadProfileImageFromURL(_ urlString: String) async {
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.profileImage = UIImage(data: data)
        } catch {
            print("Failed to load profile image: \(error)")
        }
    }
    
    // Save user data to Firestore
    func saveUserData(name: String, phoneNumber: String) {
        guard let userId = userId else { return }
        
        let userData = [
            "name": name,
            "phoneNumber": phoneNumber
        ]
        
        Firestore.firestore().collection("users").document(userId).setData(userData, merge: true) { error in
            if let error = error {
                print("Error saving user data: \(error)")
            } else {
                print("User data saved successfully!")
            }
        }
    }
}

