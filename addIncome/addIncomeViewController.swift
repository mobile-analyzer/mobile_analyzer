import UIKit
import Firebase

class addIncomeViewController: UIViewController, UITextFieldDelegate {

    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        self.incomeAmountTextField.delegate = self
        self.incomeCommentTextField.delegate = self
    }
    
    @IBOutlet weak var incomeAmountTextField: UITextField!
    @IBOutlet weak var incomeCommentTextField: UITextField!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let incomeAmount = Float(incomeAmountTextField.text!)
        let incomeComment = String(incomeCommentTextField.text!)
        if incomeAmountTextField == nil || incomeCommentTextField == nil{
            dispalayAlertMessage(userMessage: "Please, fill in the field!")
        } else {
            //Add totalIncomeAmount
            ref.child("users").child(uid!).child("income").childByAutoId().setValue(["amount": incomeAmount!, "timestamp": [".sv":"timestamp"], "comment": incomeComment ])
            
            //Editing totalExpenseAmount
            ref.child("users").child(uid!).child("income").child("totalIncomeAmount").observeSingleEvent(of: .value) { (snapshot) in
                let getTotalIncome = snapshot.value as! Float
                let update = ["users/\(self.uid!)/income/totalIncomeAmount": incomeAmount! + getTotalIncome]
                self.ref.updateChildValues(update)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func dispalayAlertMessage(userMessage:String){
        let errorAlert = UIAlertController(title: "Oops", message: userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
    
    //setup navigation bar items
    private func setupNavigationBarItems(){
        
        let titelImageView = UIImageView(image: UIImage(named: "income_Item"))
        titelImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titelImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titelImageView
    }

    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
