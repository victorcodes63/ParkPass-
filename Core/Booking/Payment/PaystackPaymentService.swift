//
//  PaystackPaymentService.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 03/04/2024.
//

import Foundation
import Paystack


class PaystackPaymentService {
    static func processPayment(withCardNumber cardNumber: String, expiryDate: String, cvv: String, amount: Int, currency: String = "KES", fromViewController viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        guard let expiryMonth = Int(expiryDate.prefix(2)),
              let expiryYear = Int("20" + expiryDate.suffix(2)) else {
            completion(false, NSError(domain: "InvalidExpiryDate", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid expiry date format."]))
            return
        }
        
        PSTCKAPIClient.shared().publicKey = "pk_test_f4427f67ce584df464a3a6676ab0f321ec9d2db2"
        
        let cardParams = PSTCKCardParams()
        cardParams.number = cardNumber
        cardParams.cvc = cvv
        cardParams.expMonth = UInt(expiryMonth)
        cardParams.expYear = UInt(expiryYear)
        
        
        let transactionParams = PSTCKTransactionParams()
        
        
        PSTCKAPIClient.shared().chargeCard(cardParams, forTransaction: transactionParams, on: viewController, didEndWithError: { error, reference in
            
            DispatchQueue.main.async {
                completion(error == nil, error)
            }
        }, didRequestValidation: { reference in
            // Handle any additional validation (e.g., OTP)
        }, didTransactionSuccess: { reference in
            DispatchQueue.main.async {
                completion(true, nil)
            }
        })
    }
}

