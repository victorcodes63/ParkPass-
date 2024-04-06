//
//  LegalOptionsView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 20/03/2024.
//

import SwiftUI

struct LegalOptionsView: View {
    var body: some View {
        Section(header: Text("Legal")) {
            HStack {
                Image(systemName: "lock.circle")
                Text("Privacy and sharing")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "creditcard.circle")
                Text("Payment Methods")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "questionmark.circle")
                Text("Visit the Help Centre")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "pencil.circle")
                Text("Give us feedback")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "dollarsign.circle")
                Text("Taxes")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "gear.badge.checkmark")
                Text("Accesibility")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "book.pages")
                Text("Terms of Service")
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "bell.badge")
                Text("Notifications")
                Spacer()
                Image(systemName: "chevron.right")
            }
           
        }
    }
}

#Preview {
    LegalOptionsView()
}
