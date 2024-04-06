//
//  BookingView.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 02/03/2024.
//




import SwiftUI
import Firebase
import Paystack
import FirebaseFirestoreInternal



struct BookingView: View {
    
    @ObservedObject var bookingManager = BookingManager()
    @State private var isBookingSuccessfulAlertPresented = false
    @State private var last4CardDigits: String? = nil
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var time = Date()
    @State private var numGuests = 1
    @State private var isShowingPaystackView = false
    @State private var isPaymentSuccessful = false
    @State private var paymentError: String? = nil
    @State private var showErrorAlert: Bool = false
    
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
    let listing: Listing
    
    var totalPrice: Int {
        numGuests * listing.pricePerActivity
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    listingInfo
                    Divider()
                    Section {
                        Text("Your Booking Details")
                            .fontWeight(.bold)
                        
                        dateSelectionView
                        Divider().padding(.vertical)
                    }
                    Spacer()
                    
                    paymentMethodView
                }
                .padding()
            }
        }
        .navigationBarTitle("Make your booking", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(paymentError ?? "An unknown error occurred"), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isShowingPaystackView)
        {PaystackPaymentView(isPaymentSuccessful: $isPaymentSuccessful, last4CardDigits: $last4CardDigits, listing: listing, totalPrice: totalPrice) { cardDetails in
            // Handle saving card details further down the road on release
        }
            
        }
        
        .alert(isPresented: $isBookingSuccessfulAlertPresented) {
            Alert(title: Text("Booking Successful"), message: Text("Your booking has been successfully made."), dismissButton: .default(Text("OK")))
        }
    }
    
    
    private var listingInfo: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image(listing.imageURLs.first ?? "")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .cornerRadius(8)
                .padding([.leading, .trailing], 2)
                
                
            
            VStack(alignment: .leading, spacing: 8) {
                Text(listing.title)
                    .font(.callout)
                    .fontWeight(.bold)
                
                HStack(spacing: 4) {
                    if let amenityImageName = listing.amenities.first?.imageName {
                        Image(systemName: amenityImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                    Text(listing.amenities.first?.title ?? "")
                        .font(.callout)
                }
                
                HStack(spacing: 4) {
                    if let featureImageName = listing.features.first?.imageName {
                        Image(systemName: featureImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                    Text(listing.features.first?.title ?? "")
                        .font(.callout)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
        }
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            DatePicker("From:", selection: $startDate, displayedComponents: .date)
            
            DatePicker("To:", selection: $endDate, displayedComponents: .date)
            Divider().padding(.vertical)
            
            DatePicker("Preferred Time", selection: $time, displayedComponents: .hourAndMinute)
            Divider().padding(.vertical)
            
            Stepper(value: $numGuests, in: 1...10) {
                Text("\(numGuests) Guests")
            }
        }
    }
        
    
    
    private var paymentMethodView: some View {
        VStack(spacing: 15) {
            Text("By selecting the button below, I agree to adhering to the Host's rules and activity rules for guests. Park Pass' rebooking and refund policy and that Park Pass can charge my payment method if I'm responsible for any damage.")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.bottom, 12)
            
            Button(action: {
                self.isShowingPaystackView = true
            }) {
                paymentButtonContent
            }
            .buttonStyle(MainButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        
    }
    
    private var paymentButtonContent: some View {
        HStack {
            Text("Pay with card")
                .fontWeight(.bold)
            Image(systemName: "creditcard.fill")
            if let last4 = last4CardDigits, !last4.isEmpty {
                Text("(**** \(last4))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color.color3, Color.color2]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(8)
    }
    
    struct MainButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity)
                .background(
                    configuration.isPressed ?
                    LinearGradient(gradient: Gradient(colors: [Color.color3.opacity(0.8), Color.color2.opacity(0.8)]), startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(gradient: Gradient(colors: [Color.color3, Color.color2]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(8)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut, value: configuration.isPressed)
        }
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(listing: DeveloperPreview.shared.listings[4])
    }
}



    
    
    
    
    
    
    
    
    
   
