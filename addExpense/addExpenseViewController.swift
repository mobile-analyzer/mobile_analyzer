import UIKit
import Firebase



class addExpenseViewController: UIViewController, UITextFieldDelegate {
    
    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    //PickerView data
    let dataSource = ["Car","Supermarkets","Cafe","Entertainment", "Other"]
    var pickerViewText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        self.selectedGroupTextField.delegate = self
        self.expenseTextField.delegate = self
        createGroupPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var selectedGroupTextField: UITextField!
    
    @IBAction func addExpense(_ sender: Any) {
        
        let expenseText = Float(expenseTextField.text!)
        if expenseTextField.text?.count == 0 || selectedGroupTextField.text?.count == 0{
            dispalayAlertMessage(userMessage: "Please, fill in all fields!")
        } else {
            //Edditing data choosed with pickerView
            ref.child("users").child(uid!).child("expense").child(self.pickerViewText!).childByAutoId().setValue(["amount": expenseText!, "timestamp": [".sv":"timestamp"] ])
            ///
            //update car limit progress if needed
            if selectedGroupTextField.text == "Car"{
                ref.child("users").child(uid!).child("carLimit").observeSingleEvent(of: .value) { (snap) in
                    if let value = snap.value as? [String:AnyObject]{
                        let progress = value["progress"] as! Float
                        let flag = value["flag"] as! String
                        if flag == "true"{
                            let update = ["users/\(self.uid!)/carLimit/progress": progress + expenseText!]
                            self.ref.updateChildValues(update)
                        }
                    }
                }
            }
            
            //update cafe limit progress if needed
            if selectedGroupTextField.text == "cafe"{
                ref.child("users").child(uid!).child("cafeLimit").observeSingleEvent(of: .value) { (snap) in
                    if let value = snap.value as? [String:AnyObject]{
                        let progress = value["progress"] as! Float
                        let flag = value["flag"] as! String
                        if flag == "true"{
                            let update = ["users/\(self.uid!)/cafeLimit/progress": progress + expenseText!]
                            self.ref.updateChildValues(update)
                        }
                    }
                }
            }
            
            //update  Entertainment limit progress if needed
            if selectedGroupTextField.text == "Entertainment"{
                ref.child("users").child(uid!).child("entertainmentLimit").observeSingleEvent(of: .value) { (snap) in
                    if let value = snap.value as? [String:AnyObject]{
                        let progress = value["progress"] as! Float
                        let flag = value["flag"] as! String
                        if flag == "true"{
                            let update = ["users/\(self.uid!)/entertainmentLimit/progress": progress + expenseText!]
                            self.ref.updateChildValues(update)
                        }
                    }
                }
            }
            
            //update  Supermarkets limit progress if needed
            if selectedGroupTextField.text == "Supermarkets"{
                ref.child("users").child(uid!).child("supermarketsLimit").observeSingleEvent(of: .value) { (snap) in
                    if let value = snap.value as? [String:AnyObject]{
                        let progress = value["progress"] as! Float
                        let flag = value["flag"] as! String
                        if flag == "true"{
                            let update = ["users/\(self.uid!)/supermarketsLimit/progress": progress + expenseText!]
                            self.ref.updateChildValues(update)
                        }
                    }
                }
            }
            
            //update  Other limit progress if needed
            if selectedGroupTextField.text == "Other"{
                ref.child("users").child(uid!).child("otherLimit").observeSingleEvent(of: .value) { (snap) in
                    if let value = snap.value as? [String:AnyObject]{
                        let progress = value["progress"] as! Float
                        let flag = value["flag"] as! String
                        if flag == "true"{
                            let update = ["users/\(self.uid!)/otherLimit/progress": progress + expenseText!]
                            self.ref.updateChildValues(update)
                        }
                    }
                }
            }
            
            ///
            
            ref.child("users").child(uid!).child("expense").child(self.pickerViewText!).child("totalAmount").observeSingleEvent(of: .value){ (snapshot) in
                let getTotalAmount = snapshot.value as! Float
                let update = ["users/\(self.uid!)/expense/\(self.pickerViewText!)/totalAmount": expenseText! + getTotalAmount]
                self.ref.updateChildValues(update)
            }
            
            //Editing totalExpenseAmount
            ref.child("users").child(uid!).child("expense").child("totalExpenseAmount").observeSingleEvent(of: .value) { (snapshot) in
                let getTotalExpense = snapshot.value as! Float
                let update = ["users/\(self.uid!)/expense/totalExpenseAmount": expenseText! + getTotalExpense]
                self.ref.updateChildValues(update)
            }
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Picker view
    func createGroupPicker() {
        let groupPicker = UIPickerView()
        groupPicker.delegate = self
        
        selectedGroupTextField.inputView = groupPicker
    }
    
    func dispalayAlertMessage(userMessage:String){
        let errorAlert = UIAlertController(title: "Oops", message: userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
    //setup navigation bar items
    private func setupNavigationBarItems(){
        
        let titelImageView = UIImageView(image: UIImage(named: "expenseItem"))
        titelImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titelImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titelImageView
    }

}

extension addExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewText = dataSource[row]
        selectedGroupTextField.text = pickerViewText
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textAlignment = .center
        label.text = dataSource[row]
        label.font = UIFont(name: "Menlo-Regular", size: 30)
        return label
    }
}
