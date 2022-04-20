//
//  BookingHistoryVC.swift


import UIKit
import SideMenu

class BookingHistoryVC: UIViewController {

    @IBOutlet weak var VwEmpty: UIView!
    @IBOutlet weak var btnParkNow: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    var count = 5
    var array = [BookingModel]()
    
    
    func setUPView() {
        self.btnParkNow.layer.cornerRadius = 6
        self.getBookingList()
        self.VwEmpty.isHidden = true
    }
    
    @IBAction func btnParkNowClick(_ sender: UIButton) {
        
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
        self.setUPView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}


extension BookingHistoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tblList.isHidden = false
        self.VwEmpty.isHidden = true
        if array.count == 0 {
            self.tblList.isHidden = true
            self.VwEmpty.isHidden = false
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
        cell.vwCell.isUserInteractionEnabled = true
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        cell.selectionStyle = .none
        return cell
    }
    
    func getBookingList() {
        _ = AppDelegate.shared.db.collection(eBooking).whereField(eEmail, isEqualTo: GFunction.user.email).order(by: eBookingStartDate, descending: true).addSnapshotListener{ querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let date : String = data1[eBookingDate] as? String, let email: String = data1[eEmail] as? String, let time: String = data1[eBookingDuration] as? String, let bookingTotalAmount : String = data1[eBookingTotalAmount] as? String,let bookingDateConfirm : String = data1[eBookingDateConfirm] as? String,let status: String = data1[eStatus] as? String,let bookingId: String = data1[eBookingId] as? String, let bookingSlotNumber: String = data1[eBookingSlotNumber] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(BookingModel(email: email, docID: data.documentID, bookingDate: date, confirmDate: bookingDateConfirm, slotNumber: bookingSlotNumber, duration: time, totalAmount: bookingTotalAmount, status: status, bookingId: bookingId))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }
        }
    }
}



class BookingCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblConfirmDate : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblBookingID : UILabel!
    @IBOutlet weak var lblSlotNo : UILabel!
    @IBOutlet weak var lblTimeSlot : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var vwCell : UIView!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 15
    }
    
    func configCell(data: BookingModel) {
        self.lblConfirmDate.text = "Confirmed on:\(data.confirmDate.description)"
        self.lblDate.text = "Date: \(data.bookingDate.dropLast(8).description)"
        self.lblSlotNo.text = "Slot number: \(data.slotNumber.description)"
        self.lblTimeSlot.text = "Duration: \(data.duration.description)"
        self.lblBookingID.text = "Booking ID: \(data.bookingId.description)"
        self.lblStatus.text = data.status.description
        
        if data.status != "Confirmed" {
            self.lblStatus.textColor = .red
        }
    }
}
