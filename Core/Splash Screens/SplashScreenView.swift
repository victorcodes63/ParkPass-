//
//  SplashScreenView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 16/03/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var animationComplete = false

    var body: some View {
        ZStack {
            Color.color1 
            VStack {
                if animationComplete {
                    LoginView(showSignInView: .constant(false))
                } else {
                    VStack {
                        Image("Logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 280, height: 280)
                            .padding(.vertical, 40)
                    }
                    .onAppear {
                        // Simulate animation completion after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut) {
                                self.animationComplete = true
                            }
                        }
                    }
                }
            }
            .onAppear {
                UINavigationBar.appearance().isHidden = true
            }
        }
        .edgesIgnoringSafeArea(.all) 
    }
}

// Preview code
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

