//
//  BookingManager.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 15/03/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

struct Booking: Identifiable, Codable {
    var id: String
    var userID: String
    var listingID: String
    var startDate: Date
    var endDate: Date
    var time: Date
    var numGuests: Int
    var title: String
    var totalPrice: Int
    var last4CardDigits: String?
    
    // Coding keys to customize encoding/decoding
    private enum CodingKeys: String, CodingKey {
        case id
        case userID = "userID"
        case listingID = "listingID"
        case startDate = "startDate"
        case endDate = "endDate"
        case time = "time"
        case numGuests = "numGuests"
        case title = "title"
        case totalPrice = "totalPrice"
        case last4CardDigits = "last4CardDigits"
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let userID = data["userId"] as? String, // Update this line
              let listingID = data["listingId"] as? String, // And this line
              let startDateTimestamp = data["startDate"] as? Timestamp,
              let endDateTimestamp = data["endDate"] as? Timestamp,
              let timeTimestamp = data["time"] as? Timestamp,
              let numGuests = data["numGuests"] as? Int,
              let totalPrice = data["totalPrice"] as? Int,
              let title = data["title"] as? String else {
            return nil
        }
        
        self.id = document.documentID
        self.userID = userID
        self.listingID = listingID
        self.startDate = startDateTimestamp.dateValue()
        self.endDate = endDateTimestamp.dateValue()
        self.time = timeTimestamp.dateValue()
        self.numGuests = numGuests
        self.totalPrice = totalPrice
        self.title = title
        self.last4CardDigits = data["last4CardDigits"] as? String
    }
}

class BookingManager: ObservableObject {
    private let db = Firestore.firestore()
    @Published var bookings: [Booking] = []
    private var listener: ListenerRegistration?
    @Published var errorMessage: String?
    
    func startFetchingBookingsForUser() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "Error: User not authenticated"
            return
        }
        
        let bookingsCollection = db.collection("bookings").whereField("userId", isEqualTo: user.uid)
        self.listener = bookingsCollection.addSnapshotListener { querySnapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error fetching bookings: \(error.localizedDescription)"
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    self.errorMessage = "No snapshot found"
                    return
                }
                
                self.bookings = snapshot.documents.compactMap { document in
                    return Booking(document: document)
                }
            }
        }
    }
    
    func stopFetchingBookings() {
        listener?.remove()
    }
    
    func updateBooking(bookingID: String, newBookingData: [String: Any], completion: @escaping () -> Void) {
        db.collection("bookings").document(bookingID).updateData(newBookingData) { error in
            if let error = error {
                print("Error updating booking: \(error.localizedDescription)")
            } else {
                print("Booking updated successfully!")
                self.startFetchingBookingsForUser()
                completion()
            }
        }
    }
    
    func deleteBooking(bookingID: String, completion: @escaping () -> Void) {
        db.collection("bookings").document(bookingID).delete { error in
            if let error = error {
                print("Error deleting booking: \(error.localizedDescription)")
            } else {
                print("Booking deleted successfully!")
                completion()
            }
        }
    }
    
    // Helper function to parse Firestore document data into a Booking object
    func parseBooking(from document: QueryDocumentSnapshot) -> Booking? {
        guard
            let userID = document.get("userID") as? String,
            let listingID = document.get("listingID") as? String,
            let title = document.get("title") as? String,
            let startDateTimestamp = document.get("startDate") as? Timestamp,
            let endDateTimestamp = document.get("endDate") as? Timestamp,
            let timeTimestamp = document.get("time") as? Timestamp,
            let numGuests = document.get("numGuests") as? Int,
            let paymentMethodRawValue = document.get("paymentMethod") as? String,
            let totalPrice = document.get("totalPrice") as? Int
        else {
            print("Error: Failed to parse booking data from document.")
            return nil
        }
        
        // Convert Timestamps to Dates
        let startDate = startDateTimestamp.dateValue()
        let endDate = endDateTimestamp.dateValue()
        let time = timeTimestamp.dateValue()
        
        // Create a Booking object
        let booking = Booking(
            id: document.documentID,
            userID: userID,
            listingID: listingID,
            startDate: startDate,
            endDate: endDate,
            time: time,
            numGuests: numGuests,
            title: title,
            totalPrice: totalPrice
        )
        
        return booking
    }
    
}
extension Booking {
    init(id: String, userID: String, listingID: String, startDate: Date, endDate: Date, time: Date, numGuests: Int, title: String, totalPrice: Int, last4CardDigits: String? = nil) {
        self.id = id
        self.userID = userID
        self.listingID = listingID
        self.startDate = startDate
        self.endDate = endDate
        self.time = time
        self.numGuests = numGuests
        self.title = title
        self.totalPrice = totalPrice
        self.last4CardDigits = last4CardDigits
    }
}
