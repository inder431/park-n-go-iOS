//
//  UserModel.swift
//  ParkingApp
//
//  Created by 2022M3 on 28/03/22.
//

import Foundation


class UserModel {
    var userName:String
    var email: String
    var password: String
    var docId: String
    
    
    init(email:String, userName: String, password: String, docID:String) {
        self.email = email
        self.userName = userName
        self.password = password
        self.docId = docID
    }
}
