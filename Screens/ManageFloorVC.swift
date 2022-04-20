//
//  ManageFloorVC.swift


import UIKit

class ManageFloorVC: UIViewController {

    @IBOutlet weak var txtFloor: UITextField!
    @IBOutlet weak var txtBlocks: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var parkingData : ParkingDataModel!
    
    func setUpView() {
        self.btnUpdate.layer.cornerRadius = 6
        self.getData()
    }
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        let err = self.validation()
        if err == "" {
            if let floor : Int = Int((self.txtFloor.text?.trim())!) , let block: Int = Int((self.txtBlocks.text?.trim())!) {
                self.updateData(name: self.txtTitle.text?.trim() ?? "", row: floor, column: block)
            }
        }else{
            Alert.shared.showAlert(message: err, completion: nil)
        }
    }
    
    func validation() -> String {
        if self.txtTitle.text?.trim() == "" {
            return "Please enter title"
        }else if self.txtFloor.text?.trim() == "" {
            return "Please enter rows"
        }else if self.txtBlocks.text?.trim() == "" {
            return "Please enter columns"
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }

    
    func updateData(name: String,row:Int, column:Int) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(eParkingData).addDocument(data:
            [
              "name": name,
              "row": row,
              "column" : column,
              "isActive" : true
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.navigationController?.popViewController(animated: true)
            }
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
                    
                    self.txtFloor.text = floor.description
                    self.txtBlocks.text = parkingSlot.description
                }
               
            }else{
                Alert.shared.showAlert(message: "No Event Found", completion: nil)
            }
        }
    }
}
