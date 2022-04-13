//
//  SignUpVC.swift


import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    
    var flag = true
    var appleData: AppleLoginModel!
    private let appleLoginManager: AppleLoginManager = AppleLoginManager()
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter name"
        }else if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtConfirmPassword.text?.trim() {
            return "Both password different"
        }
        return ""
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        if sender == btnAppleLogin {
            self.appleLoginManager.performAppleLogin()
        }else if sender == btnSignUp {
            self.flag = false
            let error = self.validation()
            if error == "" {
                self.getExistingUser(name: self.txtName.text!, email: self.txtEmail.text!, password: self.txtPassword.text!)
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    
    func setUpView() {
        self.btnSignUp.shadow()
        self.btnGoogle.backgroundColor = .white
        self.btnGoogle.shadow()
        self.btnAppleLogin.shadow()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
}


//MARK:- Extension for Login Function
extension SignUpVC {
    
    func createAccount(name: String, email:String,password:String) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(eUser).addDocument(data:
            [
              eEmail: email,
              eUserName: name,
              ePassword : password,
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.shared.firebaseRegister(data: email)
                GFunction.user = UserModel(email: email, userName: name, password: password, docID: ref!.documentID.description)
                UIApplication.shared.setHome()
                self.flag = true
            }
        }
    }
    
    func getExistingUser(name: String, email:String,password:String) {
    
        _ = AppDelegate.shared.db.collection(eUser).whereField(eEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count == 0 {
                self.createAccount(name: name, email:email, password:password)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "UserName is already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
    }
}


//MARK:- Apple Login
extension SignUpVC: AppleLoginDelegate {
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
