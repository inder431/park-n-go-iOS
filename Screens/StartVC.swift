//
//  StartVC.swift
//  ParkingApp
//
//  Created by 2022M3 on 19/03/22.
//

import UIKit

class StartVC: UIViewController {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    func setUpView() {
        self.btnRegister.backgroundColor = UIColor.white
        self.btnRegister.shadow()
        self.btnSignIn.shadow()
    }
    
    // Shadow Color and Radius
   
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnRegister {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }

}
