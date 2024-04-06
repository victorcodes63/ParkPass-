//
//  AuthenticationViewModel.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 07/03/2024.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        _ = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}


//MARK: SIGN IN EMAIL

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var confirmPassword = ""
    
    //validation of sign up form 
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
    
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
            
        }
        
        do {
            let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            _ = DBUser(auth: authDataResult)
            
            
            // Saving the user in the database
            try await UserManager.shared.createNewUser(auth: authDataResult)
            
            // Sign in the newly created user after registration
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
            
            return
            
        } catch {
            // Handle sign-up errors appropriately (e.g., throw error)
            throw error
        }
    }
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

