//
//  ManagePriceVC.swift
//  ParkingApp
//
//  Created by 2022M3 on 21/03/22.
//

import UIKit

class ManagePriceVC: UIViewController {
    
    
    @IBOutlet weak var stTime: UIStackView!
    @IBOutlet weak var stRates: UIStackView!
    @IBOutlet weak var stUpdatedRates: UIStackView!
    @IBOutlet weak var lblTime: EdgeInsetLabel!
    @IBOutlet weak var lblRates: EdgeInsetLabel!
    @IBOutlet weak var lblUpdatedPrice: EdgeInsetLabel!
    
    @IBOutlet weak var txtLessOne: UITextField!
    @IBOutlet weak var lblLessOne: EdgeInsetLabel!
    
    @IBOutlet weak var txtOneToThree: UITextField!
    @IBOutlet weak var lblOneToThree: EdgeInsetLabel!
    
    @IBOutlet weak var txtThreeToSix: UITextField!
    @IBOutlet weak var lblThreeToSix: EdgeInsetLabel!
    
    @IBOutlet weak var lblSixToTwelve: EdgeInsetLabel!
    @IBOutlet weak var txtSixToTwelve: UITextField!
    
    @IBOutlet weak var lblDaily: EdgeInsetLabel!
    @IBOutlet weak var txtDaily: UITextField!
    
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    var charges: ChargesModel!
    
    
    func setUpView(){
        self.getData()
        self.lblTime.layer.borderColor = UIColor.black.cgColor
        self.lblTime.layer.borderWidth = 1
        
        self.stRates.layer.borderColor = UIColor.black.cgColor
        self.stRates.layer.borderWidth = 1
        
        self.stTime.layer.borderColor = UIColor.black.cgColor
        self.stTime.layer.borderWidth = 1
        
        self.stUpdatedRates.layer.borderColor = UIColor.black.cgColor
        self.stUpdatedRates.layer.borderWidth = 1
        
        self.lblRates.layer.borderColor = UIColor.black.cgColor
        self.lblRates.layer.borderWidth = 1
        
        self.lblUpdatedPrice.layer.borderColor = UIColor.black.cgColor
        self.lblUpdatedPrice.layer.borderWidth = 1
        
        self.btnUpdate.layer.cornerRadius = 6
        //        self.tblRates.delegate = self
        //        self.tblRates.dataSource = self
    }
    
    
    func setUPData() {
        if self.charges != nil {
            self.lblDaily.text = "$ \(self.charges.daily)"
            self.lblLessOne.text = "$ \(self.charges.lessOne)"
            self.lblOneToThree.text = "$ \(self.charges.oneToThree)/Hr"
            self.lblThreeToSix.text = "$ \(self.charges.threeToSix)/Hr"
            self.lblSixToTwelve.text = "$\(self.charges.sixToTwelve)/Hr"
            self.txtDaily.text = "\(self.charges.daily)"
            self.txtLessOne.text = "\(self.charges.lessOne)"
            self.txtOneToThree.text = "\(self.charges.oneToThree)"
            self.txtThreeToSix.text = "\(self.charges.threeToSix)"
            self.txtSixToTwelve.text = "\(self.charges.sixToTwelve)"
        }
    }
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        let error = self.validation()
        if error == "" {
            self.updateCharges(docID: self.charges.docId, lessOne: self.txtLessOne.text!, oneToThree: self.txtOneToThree.text!, threeToSix: self.txtThreeToSix.text!, sixToTwelve: self.txtSixToTwelve.text!, daily: self.txtDaily.text!)
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
        
    }
    
    func validation() -> String {
        if self.txtLessOne.text == "" || self.txtOneToThree.text == "" || self.txtThreeToSix.text == "" || self.txtSixToTwelve.text == "" || self.txtDaily.text == "" {
            return "Please enter charges"
        }
        
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    func updateCharges(docID: String,lessOne: String, oneToThree: String, threeToSix: String, sixToTwelve: String, daily: String) {
        let ref = AppDelegate.shared.db.collection(eCharges).document(docID)
        ref.updateData([
            eLessOne: lessOne,
            eOneToThree: oneToThree,
            eThreeToSix : threeToSix,
            eSixToTwelve : sixToTwelve,
            eDaily : daily,
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
    
    func setData(lessOne: String, oneToThree: String, threeToSix: String, sixToTwelve: String, daily: String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eCharges).addDocument(data:
                                                                        [
                                                                            eLessOne: lessOne,
                                                                            eOneToThree: oneToThree,
                                                                            eThreeToSix : threeToSix,
                                                                            eSixToTwelve : sixToTwelve,
                                                                            eDaily : daily,
                                                                        ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
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
                        
                        self.setUPData()
                    }
                }
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }
    
}
