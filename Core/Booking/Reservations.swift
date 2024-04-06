//
//  Reservations.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 15/03/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Reservations: View {
    @ObservedObject var bookingManager = BookingManager()
    
    var body: some View {
        VStack (alignment: .leading) {
            if !bookingManager.bookings.isEmpty {
                List {
                    ForEach(bookingManager.bookings) { booking in
                        ReservationRow(bookingManager: bookingManager, booking: booking)
                    }
                }
            } else {
                Text("You have no reservations.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .onAppear {
            bookingManager.startFetchingBookingsForUser()
        }
        .navigationTitle("Reservations")
    }
}

struct ReservationRow: View {
  @StateObject var bookingManager: BookingManager
  let booking: Booking
  @State private var isEditing = false
  @State private var isDeleteSheetVisible = false
  
  @State private var showActionSheet = false
  
  var body: some View {
    Section {
      VStack(alignment: .leading) {
        Text("\(booking.title)")
          .font(.headline)
          .fontWeight(.bold)
        Text("\(booking.numGuests) Guests")
          .font(.subheadline)
          .fontWeight(.bold)
        Text("Charges: Ksh \(booking.totalPrice)")
          .font(.subheadline)
          .fontWeight(.bold)
        Text("Date: \(formattedDate(booking.startDate))")
          .font(.subheadline)
          .foregroundColor(.secondary)
//        Text("End Date: \(formattedDate(booking.endDate))")
//          .font(.subheadline)
//          .foregroundColor(.secondary)
//        Text("Time: \(booking.time))")
//          .font(.subheadline)
//          .foregroundColor(.secondary)
        Text("Booking ID: \(booking.id)")
          .font(.subheadline)
          .foregroundColor(.secondary)
        HStack(spacing: 15) {
          Button("Edit") {
            isEditing.toggle()
            showActionSheet = false
          }
          .foregroundColor(.white)
          .font(.caption)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.color6)
          .cornerRadius(12)
          .sheet(isPresented: $isEditing) {
            EditBookingView(bookingManager: bookingManager, booking: booking, isEditing: $isEditing)
              .presentationDetents([.medium])
          }
          
          HStack {
            Button(action: {}) {
              Text("Cancel")
                .foregroundColor(.white)
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.color2)
                .cornerRadius(12)
            }
            .onTapGesture {
              showActionSheet = true
            }
          }
        }
        .actionSheet(isPresented: $showActionSheet) {
          ActionSheet(
            title: Text("Are you sure you want to cancel your reservation?"),
            message: Text("This action cannot be undone."),
            buttons: [
              .destructive(Text("Yes, Cancel My Booking")) {
                bookingManager.deleteBooking(bookingID: booking.id) {
                  // Handle completion if needed
                }
              },
              .cancel()
            ]
          )
        }
      }
    }
  }
  
  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter.string(from: date)
  }
    
    struct EditBookingView: View {
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var bookingManager: BookingManager
        var booking: Booking
        @Binding var isEditing: Bool
        
        @State private var newStartDate = Date()
        @State private var newEndDate = Date()
        @State private var newTime = Date()
        
        var body: some View {
            VStack {
                Text("Edit Booking")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 15)
                
                DatePicker("Start Date", selection: $newStartDate, displayedComponents: .date)
                    .padding(.horizontal, 20)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()

                DatePicker("End Date", selection: $newEndDate, displayedComponents: .date)
                    .padding(.horizontal, 20)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                
                DatePicker("Preferred Time", selection: $newTime, displayedComponents: .hourAndMinute)
                    .padding(.horizontal, 20)
                    .fontWeight(.bold)
                    .padding()
            
                
                Button("Save Changes") {
                    let newBookingData: [String: Any] = [
                        "startDate": newStartDate,
                        "endDate": newEndDate,
                        "time": newTime
                    ]
                    
                    bookingManager.updateBooking(bookingID: booking.id, newBookingData: newBookingData) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.color3)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            
        }
    }
}

#Preview {
    Reservations()
}
