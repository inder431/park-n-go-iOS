//
//  SideMenuVC.swift
//  ParkingApp
//
//  Created by 2021M05 on 01/04/22.
//

import UIKit

class SideMenuModel {
    var title: String
    var type: UIViewController.Type
    
    init(title:String, type:UIViewController.Type){
        self.title = title
        self.type = type
    }
}

class SideMenuTVC: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SideMenuVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    
    //MARK:- Class Variable
    let arrayTitles = [
        "Home",
        "My Profile",
        "Parking Charges",
        "Booking History",
        "Reserve Slot",
    ]
    
    let arrData = [SideMenuModel(title: "Home", type: HomeVC.self),
                   SideMenuModel(title: "My Profile", type: UserProfileVC.self),
                   SideMenuModel(title: "Find Parking", type: ParkingRatesVC.self),
                   SideMenuModel(title: "Booking History", type: BookingHistoryVC.self),
                   SideMenuModel(title: "Reserve Slot", type: ReserveSlotVC.self),
                   SideMenuModel(title: "Customer Feedback", type: FeedbackVC.self)
                   
    ]
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    func applyStyle(){
        self.btnLogout.layer.cornerRadius = 5.0
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
}

extension SideMenuVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC") as! SideMenuTVC
        cell.lblTitle.text = arrData[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: self.arrData[indexPath.row].type) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
