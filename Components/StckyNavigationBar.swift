//
//  StckyNavigationBar.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 02/03/2024.
//

struct StickyNavigationBar: View {
    var body: some View {
        VStack {
            HStack {
                // Add your navigation bar content here
                Button(action: {
                    // Handle navigation button action
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    StckyNavigationBar()
}
