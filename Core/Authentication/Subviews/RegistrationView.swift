//
//  RegistrationView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 08/03/2024.
//


import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
  
    @Environment(\.dismiss) var dismiss
    
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showAlert = false
    @State private var alertMessage = "The email address is already in use by another account."
    
    
    var body: some View {
        ZStack { //
            Image("Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 190, height: 190)
                    .padding(.vertical, 30)
                
                
                TextField("email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                    .padding(8)
                
                
                TextField("name", text: $fullname)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                    .padding(8)
                
                SecureField("password", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                    .padding(8)
                
                SecureField("confirm password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                    .padding(8)
                
                //Sign Up Button
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            try await viewModel.signIn()
                           
                            dismiss()
                        } catch {
                            showAlert = true
                            alertMessage = error.localizedDescription
                            print("DEBUG: Kindly input correct credentials with error \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(width: UIScreen.main.bounds.width - 42, height: 48)
                        .background(Color.color3)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                NavigationLink(destination: LoginView(showSignInView: .constant(false))) {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        Text("Sign in")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 14))
                }
            }
            .padding(.horizontal)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Registration Error"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                }
           }
       }
#Preview {
    RegistrationView(showSignInView: .constant(false))
}
