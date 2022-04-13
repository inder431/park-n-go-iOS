//
//  BookingConfirmVC.swift
//  ParkingApp
//
//  Created by 2022M3 on 29/03/22.
//

import UIKit
import SideMenu

class BookingConfirmVC: UIViewController {

    
    var startTimer: Date!
    var endTimer: Date!
    var date = Date()
    var random: Int = 0
    var total: Double!
    var blockTitle: String!
    
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.menuWidth = self.view.frame.width - 50
        present(menu, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "hh:mm a"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = .short
        dateFormatter2.dateFormat = "dd MMM, yyyy hh:mm a"
        
        let today = dateFormatter2.string(from: date)
        
        let start = dateFormatter1.string(from: self.startTimer)
        let end = dateFormatter1.string(from: self.endTimer)
        let valueData = arc4random_uniform(9999 + 1)
        let expiredDate = dateFormatter2.string(from: self.endTimer)
        let confirmDate = dateFormatter2.string(from: self.startTimer)
        
        self.addBooking(start: start, end: end, value: Int(valueData), floor: self.blockTitle, today: today, total: self.total, expiredDate: expiredDate, confirmDate: confirmDate)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addBooking(start:String, end:String, value: Int, floor: String,today:String, total: Double, expiredDate: String,confirmDate: String) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(eBooking).addDocument(data:
            [
                eEmail: GFunction.user.email,
              eBookingDate: today.description,
              eBookingId: "PIN\(value.description)",
              eBookingSlotNumber: floor.description,
              eBookingDuration: "\(start) To \(end)",
              eBookingDateConfirm: today.description,
              eBookingTotalAmount: total.description,
              eBookingStatus: eConfirm,
                eBookingStartDate: confirmDate.description,
                eBookingExpiredDate: expiredDate.description
              
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                sleep(5)
                UIApplication.shared.setHome()
            }
        }
    }
}
