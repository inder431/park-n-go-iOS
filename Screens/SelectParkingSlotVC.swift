//
//  SelectParkingSlotVC.swift
//  ParkingApp
//
//

import UIKit

class ParkingSlotCVC: UICollectionViewCell {
    @IBOutlet weak var btnBookParking: UIButton!
    @IBOutlet weak var vwBookParking: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwBookParking.layer.borderColor = UIColor.black.cgColor
        self.vwBookParking.layer.borderWidth = 1.0
    }
    
    func configCell() {
    }

    
    func setEmptyCell(slotNumber: Int, floorID: String) {
        self.btnBookParking.backgroundColor = .white
        self.btnBookParking.setTitle("\(floorID) - \(slotNumber.description)", for: .normal)
        self.btnBookParking.setImage(UIImage(), for: .normal)
        self.btnBookParking.layer.borderColor = UIColor.black.cgColor
        self.btnBookParking.isSelected = false
        self.btnBookParking.layer.borderWidth = 1.0
        self.btnBookParking.isUserInteractionEnabled = true
    }
    
    func setParkedCarCell() {
        self.btnBookParking.backgroundColor = .white
        self.btnBookParking.setTitle("", for: .normal)
//        self.btnBookParking.setImage(UIImage(named: "red-car.png"), for: .normal)
        self.btnBookParking.isSelected = true
        self.btnBookParking.layer.borderColor = UIColor.black.cgColor
        self.btnBookParking.layer.borderWidth = 1.0
        self.btnBookParking.isUserInteractionEnabled = false
    }
    
    func setSelectedSlotCell() {
        self.btnBookParking.backgroundColor = UIColor.hexStringToUIColor(hex: "#CACACA")
        self.btnBookParking.setTitle("Selected", for: .normal)
        self.btnBookParking.setImage(UIImage(), for: .normal)
        self.btnBookParking.layer.borderColor = UIColor.black.cgColor
        self.btnBookParking.layer.borderWidth = 1.0
        self.btnBookParking.isSelected = false
        self.btnBookParking.isUserInteractionEnabled = false
    }
    
}

class SelectParkingSlotVC: UIViewController {

    //MARK:- Outlet
//    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var cvParkingSlot: UICollectionView!
    @IBOutlet weak var cvFloorSlot: UICollectionView!
    
    //MARK:- Class Variable
    var numberOfFloor = 4
    var arrayDisplay = 0
    var parkingData : ParkingDataModel!
    var startTime: Date!
    var endTime: Date!
    var total: Double!
    var strData = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    var index = 0
    var selectedTitle = ""
    var selectedIndex = IndexPath()
    var selectedBlock : [String] = [String]()
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.getBookedData()
        self.applyStyle()
        self.getData()
    }
    
    
    func applyStyle(){
    }
    
    //MARK:- Action Method
    @IBAction func btnSelectSlotClick(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: TimerReminderVC.self) {
            vc.startTime = self.startTime
            vc.endTime = self.endTime
            vc.total = self.total
            vc.blockTitle = self.selectedTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}

extension SelectParkingSlotVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvFloorSlot {
            return self.parkingData.floor
        }
        return self.arrayDisplay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aScalars = "A".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value
        
        if collectionView == cvParkingSlot {
            let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParkingSlotCVC", for: indexPath) as! ParkingSlotCVC
            let slotNumber = "\((Character(UnicodeScalar(aCode + UInt32(self.index))!)))".description + " - \(indexPath.row + 1)"
            if selectedBlock.contains(slotNumber) {
                colCell.setParkedCarCell()
            } else {
                colCell.setEmptyCell(slotNumber: indexPath.row + 1, floorID: "\(Character(UnicodeScalar(aCode + UInt32(self.index))!))".description)
                if self.selectedIndex == indexPath {
                    colCell.setSelectedSlotCell()
                    self.selectedTitle = "\((Character(UnicodeScalar(aCode + UInt32(self.index))!)))".description + " - \(indexPath.row + 1)"
                    print("Selected Item :- \((Character(UnicodeScalar(aCode + UInt32(self.index))!)))".description + " - \(indexPath.row + 1)")
                }
            }
           
            return colCell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FloorCVC", for: indexPath) as! FloorCVC
            cell.lblFloor.text = "Floor: \(Character(UnicodeScalar(aCode + UInt32(indexPath.item))!))"
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.cvParkingSlot.frame.width/2) - 28, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvFloorSlot {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FloorCVC", for: indexPath) as! FloorCVC
            cell.lblLine.backgroundColor = .black
            self.index = indexPath.item
            self.selectedIndex = []
            self.selectedTitle = ""
            self.cvParkingSlot.reloadData()
        } else {
            self.selectedIndex = indexPath
            self.cvParkingSlot.reloadData()
        }
    }
    
    func getData(){
        _ = AppDelegate.shared.db.collection(eParkingData).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                if let floor : Int = data1[eFloor] as? Int, let parkingSlot: Int = data1[eParkingSlot] as? Int {
                    self.parkingData = ParkingDataModel(docID: snapshot.documents[0].documentID.description, floor: floor, slot: parkingSlot)
                    
                    self.arrayDisplay = self.parkingData.slot
                    self.cvFloorSlot.delegate = self
                    self.cvFloorSlot.dataSource = self
                    self.cvFloorSlot.reloadData()
                    self.cvParkingSlot.allowsSelection = true
                    self.cvParkingSlot.allowsMultipleSelection = false
                    self.cvParkingSlot.delegate = self
                    self.cvParkingSlot.dataSource = self
                    self.cvParkingSlot.reloadData()
                }
               
            }else{
                Alert.shared.showAlert(message: "No Event Found", completion: nil)
            }
        }
    }
    
    func getBookedData() {
        _ = AppDelegate.shared.db.collection(eBooking).whereField(eStatus, isEqualTo: eConfirm).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    print("DOCID",data.documentID)
                    if GFunction.shared.checkAvaibleDate(confirmDate: (data1[eBookingStartDate] as? String)!, expiredDate: (data1[eBookingExpiredDate] as? String)!, startDate: self.startTime, endDate: self.endTime) {
                        print("Booked")
                        self.selectedBlock.append(data1[eBookingSlotNumber] as? String ?? "")
                    }
                }
                self.cvParkingSlot.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }
}


class FloorCVC: UICollectionViewCell {
    @IBOutlet weak var lblFloor: UILabel!
    @IBOutlet weak var lblLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblLine.backgroundColor = .white
    }
    
}
