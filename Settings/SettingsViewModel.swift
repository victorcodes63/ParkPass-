//
//  SettingsViewModel.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 07/03/2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "Hello123!"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
}
 
// Functions to consider further down when allowing a user to sign in anonymously and then decide to link their account to email or google

//    func linkGoogleAccount() async throws {
//        let helper = SignInGoogleHelper()
//        let tokens = try await helper.signIn()
//        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
//    }
//
//    func linkEmailAccount() async throws {
//        let email = "anotherEmail@gmail.com"
//        let password = "Hello123!"
//        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
//    }
//}
