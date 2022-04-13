//
//  LoginVC.swift


import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    
    var flag = true
    var appleData: AppleLoginModel!
    private let appleLoginManager: AppleLoginManager = AppleLoginManager()
    
   
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }
        return  ""
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnAppleLogin {
            self.appleLoginManager.performAppleLogin()
        }else if sender == btnLogin {
            self.flag = false
            let error = self.validation()
            if error == "" {
                if self.txtEmail.text == "admin@admin.com" && self.txtPassword.text == "Admin@123" {
                    UIApplication.shared.setAdmin()
                }else{
                    self.loginUser(email: self.txtEmail.text!, password: self.txtPassword.text!)
                }
                
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    
    func setUpView() {
        self.btnLogin.shadow()
        self.btnGoogle.backgroundColor = .white
        self.btnGoogle.shadow()
        self.btnAppleLogin.shadow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPassword.text = "Test@123"//"Admin@123"
        self.txtEmail.text = "test@grr.la"//"admin@admin.com"
        self.setUpView()
    }


}


//MARK:- Apple Login
extension LoginVC: AppleLoginDelegate {
    func appleLoginData(data: AppleLoginModel) {
        
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
    
        
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
           // vc.isApple = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension LoginVC {
    
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(eUser).whereField(eEmail, isEqualTo: email).whereField(ePassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let email : String = data1[eEmail] as? String, let name: String = data1[eUserName] as? String, let password: String = data1[ePassword] as? String {
                    GFunction.user = UserModel(email: email, userName: name, password: password, docID: docId)
                    GFunction.shared.firebaseRegister(data: email)
                    UIApplication.shared.setHome()
                }
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}
