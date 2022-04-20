//
//  HomeVC.swift
//  ParkingApp
//
//  Created by 2022M3 on 19/03/22.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {

    
    @IBOutlet weak var btnMenu: UIButton!
    
    
    @IBOutlet weak var vwBookingHistory: UIView!
    @IBOutlet weak var vwParkingRates: UIView!
    @IBOutlet weak var vwBookSlot: UIView!
    @IBOutlet weak var vwFavSlot: UIView!
    
    
    func setUpView() {
//        self.vwFavSlot.shadowView()
        self.vwBookSlot.shadowView()
        self.vwParkingRates.shadowView()
        self.vwBookingHistory.shadowView()
        self.vwFavSlot.isHidden = true
        self.setGesture(sender: vwParkingRates, type: ParkingRatesVC.self)
        self.setGesture(sender: vwBookingHistory, type: BookingHistoryVC.self)
        self.setGesture(sender: vwBookSlot, type: ReserveSlotVC.self)
    }
    
    func setGesture(sender: UIView, type: UIViewController.Type) {
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: type) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        sender.isUserInteractionEnabled = true
        sender.addGestureRecognizer(tap)
    }
    
    
    @IBAction func btnSideMenuTapped(_ sender: Any) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.menuWidth = self.view.frame.width - 50
        present(menu, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.setUpView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(eBooking).whereField(eStatus, isEqualTo: eConfirm).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    print("DOCID",data.documentID)
                    if GFunction.shared.checkDate(expiredDate:(data1[eBookingExpiredDate] as? String)!, currentDate: Date()) {
                        self.updateStatus(docID: data.documentID)
                    }
                }
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }
    
   
    
    
    func updateStatus(docID: String){
        let ref = AppDelegate.shared.db.collection(eBooking).document(docID)
        ref.updateData([
            eStatus: eExpired,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
