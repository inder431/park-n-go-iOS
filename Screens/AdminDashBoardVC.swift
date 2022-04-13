//
//  AdminDashBoardVC.swift

import UIKit

class AdminDashBoardVC: UIViewController {

    
    @IBOutlet weak var vwPrice: UIView!
    @IBOutlet weak var vwUser: UIView!
    @IBOutlet weak var vwFloors: UIView!
    
    
    
    func setupView() {
        self.vwUser.shadowView()
        self.vwPrice.shadowView()
        self.vwFloors.shadowView()
        
        self.setUpTouch(sender: vwPrice, type: ManagePriceVC.self)
        self.setUpTouch(sender: vwUser, type: ManageUserVC.self)
        self.setUpTouch(sender: vwFloors, type: ManageFloorVC.self)
    }
    
    func setUpTouch(sender: UIView, type: UIViewController.Type) {
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: type) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        sender.isUserInteractionEnabled = true
        sender.addGestureRecognizer(tap)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
//    }


}
