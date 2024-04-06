//
//  InputView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 21/02/2024.
//

import SwiftUI

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(showSignInView: .constant(false))
    }
}

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading , spacing: 10) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .padding(.vertical, 8) // Add vertical padding
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .padding(.vertical, 8) // Add vertical padding
            }
            Divider()
        }
    }
}
