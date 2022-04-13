//
//  BookingModel.swift

import Foundation

class BookingModel {
   
    var email: String
    var docID: String
    var bookingDate: String
    var confirmDate: String
    var slotNumber: String
    var duration: String
    var totalAmount: String
    var status: String
    var bookingId: String
    
    
    init(email: String, docID:String, bookingDate:String, confirmDate:String, slotNumber:String, duration:String, totalAmount:String, status:String, bookingId:String){
        self.email = email
        self.totalAmount = totalAmount
        self.bookingDate = bookingDate
        self.confirmDate = confirmDate
        self.docID = docID
        self.slotNumber = slotNumber
        self.status = status
        self.duration = duration
        self.bookingId = bookingId
    }

}
