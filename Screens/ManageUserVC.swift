//
//  ManageUserVC.swift

import UIKit

class ManageUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrParkModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorSet", for: indexPath) as! FloorSet
        let data = self.arrParkModel[indexPath.row]
        cell.lblTitle.text = data.name.description
        cell.btnUpdate.isSelected = data.isActive
        cell.btnUpdate.addAction(for: .touchUpInside) {
            cell.btnUpdate.isSelected.toggle()
            cell.btnUpdate.isSelected ? self.updateData(docID: data.docID, isActive: true) : self.updateData(docID: data.docID, isActive: false)
        }
        return cell
    }
    

   
    @IBOutlet weak var tblFloorList: UITableView!
    @IBOutlet weak var btnUpdate: UIButton!

    var arrParkModel = [ParkingModel]()


    func setUpView(){
        self.getParkingData()
//        self.tblFloorList.delegate = self
//        self.tblFloorList.dataSource = self
        self.btnUpdate.layer.cornerRadius = 6
    }
    
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }

    
    func getParkingData() {
        _ = AppDelegate.shared.db.collection(eParkingData).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                self.arrParkModel.removeAll()
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let floor : String = data1["name"] as? String, let row: Int = data1["row"] as? Int, let column: Int = data1["column"] as? Int, let isActive: Bool = data1["isActive"] as? Bool {
                        self.arrParkModel.append(ParkingModel(docID: data.documentID.description, name: floor, row: row, column: column,isActive: isActive))
                    }
                }
                self.tblFloorList.dataSource = self
                self.tblFloorList.delegate = self
                self.tblFloorList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Charges Found", completion: nil)
            }
        }
        
    }
    
    func updateData(docID:String,isActive: Bool) {
        let ref = AppDelegate.shared.db.collection(eParkingData).document(docID)
        ref.updateData([
            "isActive": isActive,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
//                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                self.getParkingData()
//                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}



class FloorSet: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var vwCell: UIView!
    
    
}
