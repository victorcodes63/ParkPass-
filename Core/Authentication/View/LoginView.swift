//
//  LoginView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 21/02/2024.
//
import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    
    struct GoogleSignInButton: UIViewRepresentable {
        func makeUIView(context: Context) -> GIDSignInButton {
            return GIDSignInButton()
        }
        
        func updateUIView(_ uiView: GIDSignInButton, context: Context) {
            
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 0)
                
                
                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 230, height: 230)
                        .padding(.vertical, 40)
                    
                    Spacer()
                    Spacer()
                    
                    // Sign In with Google Button
                    Button {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                showSignInView = false
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Sign In with Google")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color.color5)
                        .cornerRadius(10)
                        .frame(width: UIScreen.main.bounds.width - 62, height: 48)
                    }
                    Text("or")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding()
                    
                    // Sign In With Email Navigation Link
                    NavigationLink {
                        SignInEmailView(showSignInView: $showSignInView)
                    } label: {
                        Text("Sign In With Email")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 162, height: 48)
                            .background(Color.color3)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // Sign Up Navigation Link
                    NavigationLink(destination: RegistrationView(showSignInView: .constant(false))) {
                        HStack(spacing: 3) {
                            Text("Don't have an account?")
                                .foregroundColor(.white)
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .font(.system(size: 14))
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showSignInView: .constant(false))
    }
}
