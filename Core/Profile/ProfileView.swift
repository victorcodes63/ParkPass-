//
//  ProfileView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 21/02/2024.
//


import SwiftUI
import PhotosUI
import Firebase


struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedImage: UIImage? = nil
    @State private var name: String = ""
    
    @State private var phoneNumber: String = ""
    @State private var isShowingImagePicker = false
    @FocusState private var isInputActive: Bool
    
    var body: some View {
            List {
                Section{
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            if let profileImage = viewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            Button(action: {
                                isShowingImagePicker.toggle()
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0.7))
                                    .clipShape(Circle())
                                    
                            }
                            .padding(6)
                            .offset(x: -10, y: 10)
                        }
                        .fullScreenCover(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                        }
                    }
                    .padding(.vertical)
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets())
                .background(Color(UIColor.systemBackground))
                
                
                // Personal Info Section
                Section(header: Text("Personal Info")) {
                    // Display user details
                    if viewModel.isLoadingUserData {
                        Text("loading.....")
                    } else {
                        HStack {
                            Text("Name:")
                                .font(.subheadline)
                            Spacer()
                            Text(viewModel.name) // Display the name or a placeholder
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
                    }
                    HStack {
                            Text("Email:")
                                .font(.subheadline)
                            Spacer()
                            Text(viewModel.email) // Display user's email
                                .font(.subheadline)
                                .fontWeight(.light)
                        }
//                    HStack {
//                        Text("Phone Number:")
//                            .font(.subheadline)
//                        Spacer()
//                        TextField("", text: $phoneNumber)
//                            .focused($isInputActive)
//                            .font(.caption)
//                            .fontWeight(.light)
//                            .keyboardType(.numberPad)
//                            .onTapGesture {
//                                
//                            }
//                    }
//                        HStack {
//                            Text("UserId:")
//                                .font(.subheadline)
//                            Spacer()
//                            Text(viewModel.)
//                                .font(.subheadline)
//                                .fontWeight(.light)
//                        }
                }
                
                
                // Legal Section
                LegalOptionsView()
                
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            }
            .onAppear {
                addTapGestureToDismissKeyboard()
            }
            
        }
        private func addTapGestureToDismissKeyboard() {
            let tapGesture = UITapGestureRecognizer(target: UIApplication.shared.windows.first, action: #selector(UIApplication.shared.windows.first?.endEditing))
            tapGesture.cancelsTouchesInView = false
            UIApplication.shared.windows.first?.addGestureRecognizer(tapGesture)
        }
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Environment(\.presentationMode) var presentationMode
        @Binding var selectedImage: UIImage?
        
        var sourceType: UIImagePickerController.SourceType
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = sourceType
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.selectedImage = uiImage
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(showSignInView: .constant(false))
        }
    }
