//
//  UserProfileVC.swift
//  ParkingApp

import UIKit
import SideMenu

class UserProfileVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    
    //MARK:- Class Variable
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.btnSave.layer.cornerRadius = 6
        
        if GFunction.user != nil {
            self.lblName.text = GFunction.user.userName.description
            self.lblEmail.text = GFunction.user.email.description
            self.txtPassword.text = GFunction.user.password.description
            self.txtCPassword.text = GFunction.user.password.description
        }
    }
    
    //MARK:- Action Method
    @IBAction func btnMenuClick(_ sender: UIButton) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.menuWidth = self.view.frame.width - 50
        present(menu, animated: true)
    }
    
    
    func validation() -> String {
        
        if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }else if self.txtCPassword.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtCPassword.text?.trim() {
            return "Both password different"
        }
        return ""
    }
    @IBAction func btnSaveClick(_ sender: UIButton) {
        let err = self.validation()
        if err == "" {
            self.updateUSerData(docID: GFunction.user.docId, password: self.txtPassword.text!)
        }else{
            Alert.shared.showAlert(message: err, completion: nil)
        }
    }
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

    
    func updateUSerData(docID: String,password:String) {
        let ref = AppDelegate.shared.db.collection(eUser).document(docID)
        ref.updateData([
            ePassword: password,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                UIApplication.shared.setHome()
            }
        }
    }
}
