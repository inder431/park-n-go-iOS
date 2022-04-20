//
//  TimerReminderVC.swift


import UIKit

class TimerReminderVC: UIViewController {

    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var timer: Timer!
    var count: Int = 300
    var startTime: Date!
    var endTime: Date!
    var total: Double!
    var blockTitle: String!
    var selectedFloor: String!
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnConfirm {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: BookingConfirmVC.self) {
                vc.startTimer = self.startTime
                vc.endTimer = self.endTime
                vc.total = self.total
                vc.blockTitle = self.blockTitle
                vc.selectedFloor = self.selectedFloor
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            UIApplication.shared.setHome()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.btnCancel.layer.cornerRadius = 5.0
        self.btnConfirm.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeString), userInfo: nil, repeats: true)
    }

    
   
    
    @objc func timeString() {
        self.count -= 1
        
        if self.count > 0 {
            if self.count >= 3600 {
                self.lblMinutes.text  = "\(String(format:"%02i:%02i:%02i", Int(self.count / 3600), Int(self.count / 60), Int(self.count % 60))) Minutes"
                
            }else{
                self.lblMinutes.text  = "\(String(format:"%02i:%02i", Int(self.count / 60), Int(self.count % 60))) Minutes"
            }
        } else {
            timer.invalidate()
        }
    }
}
