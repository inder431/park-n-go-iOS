//
//  ParkingRatesVC.swift


import UIKit
import SideMenu

class ParkingRatesVC: UIViewController {

    @IBOutlet weak var lblTime: EdgeInsetLabel!
    @IBOutlet weak var lblRates: EdgeInsetLabel!
    
    @IBOutlet weak var btnSlotReserve: UIButton!
    
    @IBOutlet weak var lblLessOne: EdgeInsetLabel!
    @IBOutlet weak var lblOneToThree: EdgeInsetLabel!
    @IBOutlet weak var lblThreeToSix: EdgeInsetLabel!
    @IBOutlet weak var lblSixToTwelve: EdgeInsetLabel!
    @IBOutlet weak var lblDaily: EdgeInsetLabel!
    
    @IBOutlet weak var stTimes: UIStackView!
    @IBOutlet weak var stRates: UIStackView!
    
    var charges: ChargesModel!
    
    func setUpView(){
        self.lblTime.layer.borderColor = UIColor.black.cgColor
        self.lblTime.layer.borderWidth = 1
        
        self.stRates.layer.borderColor = UIColor.black.cgColor
        self.stRates.layer.borderWidth = 1
        
        self.stTimes.layer.borderColor = UIColor.black.cgColor
        self.stTimes.layer.borderWidth = 1
        
        self.lblRates.layer.borderColor = UIColor.black.cgColor
        self.lblRates.layer.borderWidth = 1
        
        self.btnSlotReserve.layer.cornerRadius = 6
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
        }
    }
    
    @IBAction func btnReserveSlotClick(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: ReserveSlotVC.self) {
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
        self.setUpView()
        self.getData()
        // Do any additional setup after loading the view.
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
                        
                        self.setUPData()
                    }
                }
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }

}

class RatesCell: UITableViewCell {
    
}
