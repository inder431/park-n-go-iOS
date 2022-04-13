//
//  ReserveSlotVC.swift
//  ParkingApp
//
//  Created by 2022M3 on 28/03/22.
//

import UIKit
import SideMenu

class ReserveSlotVC: UIViewController, UITextFieldDelegate {

    

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var lblSubTotal: EdgeInsetLabel!
    @IBOutlet weak var lblGST: EdgeInsetLabel!
    @IBOutlet weak var lblQST: EdgeInsetLabel!
    @IBOutlet weak var lblFinalAmount: EdgeInsetLabel!
    
    
    var charges: ChargesModel!
    var dpDateTime = UIDatePicker()
    var dpTimer = UIDatePicker()
    var toolBar = UIToolbar()
    var subTotal: Double = 0.0
    var totalAmount: Double = 0.0
    
    
    func createDatePicker(){
        
        dpDateTime.backgroundColor = UIColor.black
        dpDateTime.preferredDatePickerStyle = .wheels
        dpDateTime.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        dpTimer.backgroundColor = UIColor.black
        dpTimer.preferredDatePickerStyle = .wheels
        dpTimer.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        
        var components = DateComponents()
        components.month = 2
        dpDateTime.minimumDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(), to: Date())
        dpDateTime.maximumDate = Calendar(identifier: .gregorian).date(byAdding: components, to: Date())
        
        txtStartDate.inputView = dpDateTime
        txtEndDate.inputView = dpTimer
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.green
        toolBar.sizeToFit()
        toolBar.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtEndDate.inputAccessoryView = toolBar
        txtStartDate.inputAccessoryView = toolBar
        dpDateTime.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        dpTimer.addTarget(self, action: #selector(changeValue1), for: .valueChanged)
    }
    
    @objc func cancelClick() {
        self.txtEndDate.resignFirstResponder()
        self.txtStartDate.resignFirstResponder()
    }

    @objc func changeValue(){
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "dd-MM-yyyy hh:mm a"
        self.txtStartDate.text = dateFormatter1.string(from: dpDateTime.date)
        dpTimer.minimumDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(), to: dpDateTime.date)
    }
    
    @objc func changeValue1(){
        self.subTotal = 0.0
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "dd-MM-yyyy hh:mm a"
        self.txtEndDate.text = dateFormatter1.string(from: dpTimer.date)
        self.calculateData()
    }
    
    
    func calculateData() {
        let hours = Calendar.current.dateComponents([.hour], from: dpDateTime.date, to: dpTimer.date).hour!
        if hours < 1 {
            self.subTotal = self.subTotal + Double(self.charges.lessOne)!
        }else if (hours >= 1 && hours < 3){
            self.subTotal = self.subTotal + (Double(self.charges.oneToThree)! * Double(hours))
        }else if (hours >= 3 && hours < 6){
            self.subTotal = self.subTotal + (Double(self.charges.threeToSix)! * Double(hours))
        }else if (hours >= 6 && hours < 12){
            self.subTotal = self.subTotal + (Double(self.charges.sixToTwelve)! * Double(hours))
        }else if hours >= 12 {
            self.subTotal = self.subTotal + (Double(self.charges.daily)!)
        }
        
        
        self.setUpTotal()
    }
    
    
    func setUpTotal(){
        let subtotal = self.subTotal
        let GST = (self.subTotal * 0.05).rounded(toPlaces: 2)
        let QST = (self.subTotal * 0.10).rounded(toPlaces: 2)
        
        self.totalAmount = (self.subTotal.rounded(toPlaces: 2) + GST + QST)
        self.lblSubTotal.text = "\(amountBeforeTax)\(subtotal.description)"
        self.lblGST.text = "\(amountGST)\(GST.description)"
        self.lblQST.text = "\(amountQST)\(QST.description)"
        self.lblFinalAmount.text = "\(finalAmount)\(self.totalAmount.description)"
    }
    
    @IBAction func btnReserveClick(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SelectParkingSlotVC.self) {
            vc.startTime = dpDateTime.date
            vc.endTime = dpTimer.date
            vc.total = self.totalAmount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.menuWidth = self.view.frame.width - 50
        present(menu, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getData()
        self.createDatePicker()
        self.txtStartDate.delegate = self
        self.txtEndDate.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(eCharges).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let lessOne : String = data1[eLessOne] as? String, let oneToThree: String = data1[eOneToThree] as? String, let threeToSix: String = data1[eThreeToSix] as? String, let sixToTwelve : String = data1[eSixToTwelve] as? String, let daily : String = data1[eDaily] as? String {
                        self.charges = ChargesModel(lessOne: lessOne, oneToThree: oneToThree, threeToSix: threeToSix, sixToTwelve: sixToTwelve, daily: daily, docID: data.documentID.description)
                    }
                }
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }
}
