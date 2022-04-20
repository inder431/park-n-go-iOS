//
//  DemoSheetVC.swift
//  ParkingApp


import UIKit
import SpreadsheetView

class DemoSheetVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private let spreadsheetView = SpreadsheetView()
    var arrParkModel = [ParkingModel]()
    var startTime: Date!
    var endTime: Date!
    var total: Double!
    var strData = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    var index = 0
    var selectedTitle = ""
    var selectedFloor = ""
    var selectedIndex = IndexPath()
    var selectedBlock : [String] = [String]()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spreadsheetView.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height - 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getParkingData()
        spreadsheetView.register(HourCell.self, forCellWithReuseIdentifier: String(describing: HourCell.self))
        self.view.addSubview(spreadsheetView)
        // Do any additional setup after loading the view.
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return self.arrParkModel[index].column
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return self.arrParkModel[index].row
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 200
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let aScalars = "A".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value
        
        //        if spreadsheetView == spreadsheetView {
        let colCell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
        colCell.configData(data:  "R\(indexPath.row)C\(indexPath.column)")
        //            let slotNumber = "\((Character(UnicodeScalar(aCode + UInt32(self.index))!)))".description + " - \(indexPath.row + 1)"
        //            if selectedBlock.contains(slotNumber) {
        //                colCell.setParkedCarCell()
        //            } else {
        //                colCell.setEmptyCell(slotNumber: indexPath.row + 1, floorID: "\(Character(UnicodeScalar(aCode + UInt32(self.index))!))".description)
        //                if self.selectedIndex == indexPath {
        //                    colCell.setSelectedSlotCell()
        //                    self.selectedTitle = "\((Character(UnicodeScalar(aCode + UInt32(self.index))!)))".description + " - \(indexPath.row + 1)"
        //                    print("Selected Item :- \((Character(UnicodeScalar(aCode + UInt32(self.index))!)))".description + " - \(indexPath.row + 1)")
        //                }
        //            }
        
        return colCell
        //        }else{
        //            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "FloorCVC", for: indexPath) as! FloorCVC
        //            cell.lblFloor.text = "Floor: \(Character(UnicodeScalar(aCode + UInt32(indexPath.item))!))"
        //            return cell
        //        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("R\(indexPath.row)C\(indexPath.column)")
    }
    
    //    func getData(){
    //        _ = AppDelegate.shared.db.collection(eParkingData).addSnapshotListener{ querySnapshot, error in
    //
    //            guard let snapshot = querySnapshot else {
    //                print("Error fetching snapshots: \(error!)")
    //                return
    //            }
    //
    //            if snapshot.documents.count != 0 {
    //                let data1 = snapshot.documents[0].data()
    //                if let floor : Int = data1[eFloor] as? Int, let parkingSlot: Int = data1[eParkingSlot] as? Int {
    //                    self.parkingData = ParkingDataModel(docID: snapshot.documents[0].documentID.description, floor: floor, slot: parkingSlot)
    //
    //                    self.arrayDisplay = self.parkingData.slot
    //                }
    //
    //            }else{
    //                Alert.shared.showAlert(message: "No Event Found", completion: nil)
    //            }
    //        }
    //    }
    
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
                //                self.cvParkingSlot.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }
    
    func getParkingData() {
        _ = AppDelegate.shared.db.collection(eParkingData).whereField("isActive", isEqualTo: true).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let floor : String = data1["name"] as? String, let row: Int = data1["row"] as? Int, let column: Int = data1["column"] as? Int {
                        self.arrParkModel.append(ParkingModel(docID: data.documentID.description, name: floor, row: row, column: column, isActive: true))
                    }
                }
                self.spreadsheetView.dataSource = self
                self.spreadsheetView.delegate = self
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
    }
}


class HourCell: Cell {
    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        button.frame = bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.backgroundColor = .white
        button.setImage(UIImage(), for: .normal)
        if let image = UIImage(named: "red-car.png") {
            button.setImage(image, for: .selected)
        }
        button.layer.borderColor = UIColor.black.cgColor
        button.isSelected = false
        button.layer.borderWidth = 1.0
        button.isUserInteractionEnabled = true
        button.setTitleColor(.black, for: .normal)
        button.isUserInteractionEnabled = false
        addSubview(button)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configData(data: String) {
        button.frame = bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.backgroundColor = .white
        button.setImage(UIImage(), for: .normal)
        if let image = UIImage(named: "red-car.png") {
            button.setImage(image, for: .selected)
        }
        button.layer.borderColor = UIColor.black.cgColor
        button.isSelected = false
        button.layer.borderWidth = 1.0
        button.isUserInteractionEnabled = false
        button.setTitleColor(.black, for: .normal)
        self.button.setTitle(data, for: .normal)
    }
    
    func selectedCar() {
        button.frame = bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.backgroundColor = .white
        button.setImage(UIImage(), for: .normal)
        button.setTitle("", for: .normal)
        button.setTitle("", for: .selected)
        button.layer.borderColor = UIColor.black.cgColor
        button.isSelected = true
        button.isUserInteractionEnabled = false
        button.layer.borderWidth = 1.0
//        addSubview(button)
    }
    
    func selectedParking(){
        self.button.isSelected = false
        self.button.backgroundColor = UIColor.hexStringToUIColor(hex: "#CACACA")
        self.button.setTitle("Selected", for: .normal)
        self.button.setTitleColor(.themePurple, for: .normal)
        self.button.layer.borderColor = UIColor.black.cgColor
        self.button.layer.borderWidth = 1.0
        self.button.isUserInteractionEnabled = false
    }
}
