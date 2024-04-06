//
//  SettingsView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 03/03/2024.
//

import SwiftUI
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Section(header: Text("Account")) {
                Button(action: {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    Label("Log out", systemImage: "arrow.left.square.fill")
                }
                .foregroundColor(.red)
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            showSignInView = true
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    Label("Delete account", systemImage: "trash.fill")
                }
                .foregroundColor(.red)
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationBarTitle("Settings")
        
    }
}
               

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    
    private var emailSection: some View {
        Section(header: Text("Email Functions")) {
            Button(action: {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET!")
                    } catch {
                        print(error)
                    }
                }
            }) {
                Label("Reset password", systemImage: "key.fill")
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED!")
                    } catch {
                        print(error)
                    }
                }
            }) {
                Label("Update password", systemImage: "lock.rotation.open")
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED!")
                    } catch {
                        print(error)
                    }
                }
            }) {
                Label("Update email", systemImage: "envelope.fill")
            }
        }
    }
}

    
//MARK: Further consideration when allowing user to sign in anonymously
    
    
//    private var anonymousSection: some View {
//        Section {
//            Button("Link Google Account") {
//                Task {
//                    do {
//                        try await viewModel.linkGoogleAccount()
//                        print("GOOGLE LINKED!")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//
//            Button("Link Apple Account") {
//                Task {
//                    do {
//                        try await viewModel.linkAppleAccount()
//                        print("APPLE LINKED!")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//
//            Button("Link Email Account") {
//                Task {
//                    do {
//                        try await viewModel.linkEmailAccount()
//                        print("EMAIL LINKED!")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        } header: {
//            Text("Create account")
//        }
//    }
//}
