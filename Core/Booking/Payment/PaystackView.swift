//
//  PaystackView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 03/04/2024.
//

import SwiftUI
import Combine
import Paystack
import Firebase
import FirebaseFirestoreInternal

enum ActiveAlert {
    case success, error
}

struct SavedCardDetails: Codable {
    let cardNumber: String
    let expirationDate: String
    let cvc: String
}

struct PaystackPaymentView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPaymentSuccessful: Bool
    @Binding var last4CardDigits: String?
    @ObservedObject var bookingManager = BookingManager()
    @StateObject private var viewModel = ProfileViewModel()
   
    
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    @State private var saveCardDetails: Bool = false
   
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var paymentError: String? = nil
    
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var time = Date()
    @State private var numGuests = 1
    @State private var isShowingPaystackView = false
   
    // Alert control
    @State private var activeAlert: ActiveAlert = .success
    @State private var showAlert = false
    
    
    let listing: Listing
    let totalPrice: Int
    
    var onSaveCardDetails: ((SavedCardDetails) -> Void)?
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack {
                headerView
                cardDetailsForm
                Spacer()
                payButton
            }
            .padding()
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .success:
                        return Alert(
                            title: Text("Booking Confirmed"),
                            message: Text("Your booking is confirmed."),
                            dismissButton: .default(Text("OK")) {
                                // Handle navigation or actions on success
                                self.presentationMode.wrappedValue.dismiss() // Navigate back
                            }
                        )
                    case .error:
                        return Alert(
                            title: Text("Error"),
                            message: Text(paymentError ?? "An error occurred during the booking process."),
                            dismissButton: .default(Text("OK")) {
                                // Handle navigation or actions on error
                                self.presentationMode.wrappedValue.dismiss() // Navigate back
                            }
                        )
                    }
                }
            }
    
    private var headerView: some View {
        HStack {
            Text("Complete Your Payment")
                .font(.headline)
                .fontWeight(.bold)
            
        }
        .padding(.horizontal)
        .padding(.top, 10)
       
    }
    
    private var cardDetailsForm: some View {
        GroupBox(label: Label("Card Details", systemImage: "creditcard.fill").foregroundColor(.black)) {
            TextField("Card Number", text: $cardNumber)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .onReceive(Just(cardNumber)) { newValue in
                    // Filter out any non-numeric characters to ensure input is numbers only.
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    
                    // Limit the content to 12 digits.
                    let limited = String(filtered.prefix(16))
                    
                    // Insert spaces every 4 digits to format it as needed.
                    let formatted = limited.enumerated().map { index, character -> String in
                        return index % 4 == 0 && index != 0 ? " \(character)" : "\(character)"
                    }.joined()
                    
                    // Update the cardNumber state with the formatted string.
                    self.cardNumber = formatted
                }
            
            TextField("MM/YY", text: $expiryDate)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .onReceive(Just(expiryDate)) { newValue in
                    //Filter out any non-numeric characters to ensure input is numbers only.
                    var filtered = newValue.filter { "0123456789".contains($0) }

                    //Limit the content to 4 digits to conform to the MM/YY format.
                    filtered = String(filtered.prefix(4))
                    
                    //Format the string with a slash if it's longer than 2 characters.
                    if filtered.count > 2 {
                        // Insert a slash after the first two digits.
                        let index = filtered.index(filtered.startIndex, offsetBy: 2)
                        filtered = String(filtered.prefix(2)) + "/" + filtered.suffix(from: index)
                    }
                    
                    // Update only if the filtered value differs, to prevent endless loop.
                    if filtered != newValue {
                        self.expiryDate = filtered
                    }
                }

            
            TextField("CVV", text: $cvv)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .onReceive(Just(cvv)) { newValue in
                    // Ensure that only numeric characters are allowed.
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered.count > 3{
                        self.cvv = String(filtered.prefix(3))
                    } else {
                        self.cvv = filtered
                    }
                }
            
            Toggle("Save Card Details", isOn: $saveCardDetails)
                .padding(.vertical, 10)
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
    
    
    private var payButton: some View {
        Button(action: {
            processPayment { success in
                if success {
                    uploadBookingDetails()
                } else {
                    print("Payment failed. Booking details were not uploaded.")
                }
            }
        }) {
            Text("Pay \(totalPrice) Ksh")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.color3.opacity(0.9), Color.color3.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
                .shadow(radius: 5)
        }
        .padding()
    }
    
    
    private func processPayment(completion: @escaping (Bool) -> Void) {
            guard let expiryMonth = Int(expiryDate.prefix(2)),
                  let expiryYear = Int(expiryDate.suffix(2)),
                  !cardNumber.isEmpty, !cvv.isEmpty else {
                paymentError = "Invalid card details"
                showingErrorAlert = true
                completion(false)
                return
            }

            let cardParams = PSTCKCardParams()
            cardParams.number = cardNumber
            cardParams.cvc = cvv
            cardParams.expMonth = UInt(expiryMonth)
            cardParams.expYear = UInt(expiryYear)
        
            let user = viewModel.user
            let transactionParams = PSTCKTransactionParams()
            transactionParams.amount = UInt(truncating: NSNumber(value: totalPrice * 100))
            transactionParams.email = user?.email ?? "default@email.com"
            transactionParams.currency = "KES"
        
        PSTCKAPIClient.shared().chargeCard(cardParams, forTransaction: transactionParams, on: UIViewController.topViewController()!,
               didEndWithError: { error, reference in
                   DispatchQueue.main.async {
                       self.paymentError = error.localizedDescription
                       self.activeAlert = .error
                       self.showAlert = true
                   }
                   completion(false)
               },
               didRequestValidation: { reference in
                   // Handle validation as needed
               },
               didTransactionSuccess: { reference in
                   DispatchQueue.main.async {
                       self.activeAlert = .success
                       self.showAlert = true
                   }
                   completion(true)
               })
       }

    
    private func uploadBookingDetails() {
            let db = Firestore.firestore()

            let bookingData: [String: Any] = [
                "listingId": listing.id,
                "title": listing.title,
                "startDate": startDate,
                "endDate": endDate,
                "time": time,
                "numGuests": numGuests,
                "totalPrice": totalPrice,
                "last4CardDigits": last4CardDigits ?? "",
                "userId": Auth.auth().currentUser?.uid ?? "",
                "createdAt": FieldValue.serverTimestamp()
            ]

        db.collection("bookings").addDocument(data: bookingData) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.paymentError = "Failed to upload booking details: \(error.localizedDescription)"
                        self.activeAlert = .error
                        self.showAlert = true
                    } else {
                        self.isPaymentSuccessful = true
                        self.activeAlert = .success
                        self.showAlert = true
                    }
                }
            }
        }
    
        private func presentError(_ message: String) {
            paymentError = message
            showingErrorAlert = true
        }
    }
    
struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .textCase(nil)
                .font(.headline)
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
    }
}

extension UIViewController {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.rootViewController) -> UIViewController? {
            if let nav = viewController as? UINavigationController {
                return topViewController(nav.visibleViewController)
            } else if let tab = viewController as? UITabBarController, let selected = tab.selectedViewController {
                return topViewController(selected)
            } else if let presented = viewController?.presentedViewController {
                return topViewController(presented)
            }
            return viewController
        }
}
