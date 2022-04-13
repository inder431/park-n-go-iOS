//
//  FeedbackVC.swift
//  ParkingApp
//

import UIKit
import SideMenu

class FeedbackVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK:- Class Variable
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.btnSubmit.layer.cornerRadius = 6
    }
    
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.menuWidth = self.view.frame.width - 50
        present(menu, animated: true)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        UIApplication.shared.setHome()
    }
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
}
