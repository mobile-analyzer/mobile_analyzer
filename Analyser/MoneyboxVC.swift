import UIKit
import Firebase

/// Страница с копилкой
class MoneyboxVC: UIViewController {
    
    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var savedMoney: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        getSavedMoney()
    }
    
    /// Расчет сохраненных средств
    func getSavedMoney(){
        ref.child("users").child(uid!).child("income").observeSingleEvent(of: .value) { (snap) in
            if let value = snap.value as? [String:AnyObject]{
                let income = value["totalIncomeAmount"] as! Int
                self.ref.child("users").child(self.uid!).child("expense").observeSingleEvent(of: .value) { (snap) in
                    if let value = snap.value as? [String:AnyObject]{
                        let expense = value["totalExpenseAmount"] as! Int
                        if expense > income{
                            self.savedMoney.text = String(0)
                        }else{
                            self.savedMoney.text = String(income - expense)
                        }
                        
                    }
                }
            }
        }
    }
}
