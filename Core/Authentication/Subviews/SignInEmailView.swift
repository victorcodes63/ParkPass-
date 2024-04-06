//
//  SignInEmailView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 07/03/2024.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var showAlert = false
    @State private var navigateToRegistration = false
    
    var body: some View {
        ZStack { //
            Image("Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Image
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .padding(.vertical, 80)
                
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                    .padding()
                
                // Sign In Button
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            showAlert = true
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 42, height: 50)
                        .background(Color.color3)
                        .cornerRadius(10)
                    
                }
                .padding()
                
                Spacer()
                
                
               NavigationLink(destination: RegistrationView(showSignInView: .constant(false))) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 14))
                }
                .padding(.horizontal)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign In Error"),
                  message: Text("Incorrect email or password. Please try again or Sign Up for an account."),
                  dismissButton: .default(Text("OK")))
            
        }
    }
}


struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}

