//
//  UserServiceProtocol.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 02/03/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol UserServiceProtocol {
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
}

class UserService: UserServiceProtocol {
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "UserServiceError", code: 1, userInfo: ["message": "No user logged in"])))
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                completion(.failure(NSError(domain: "UserServiceError", code: 2, userInfo: ["message": "Failed to retrieve user data"])))
                return
            }

            do {
                //let user = try snapshot.data(as: User.self)
                //completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func signOut() {
        // Implement sign out logic using FirebaseAuth
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
    }
}
