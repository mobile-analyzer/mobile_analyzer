import UIKit
import Firebase

class EntertainmentLimitViewController: UIViewController {

    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createPageTitle()
        
        ref.child("users").child(uid!).child("entertainmentLimit").observe(.value) { (snap) in
            if let value = snap.value as? [String:AnyObject]{
                let progress = value["progress"] as! Double
                let limit = value["limit"] as! Double
                if progress > limit{
                    let alert = UIAlertController(title: nil, message: "Exceeded the limit on the category of cars!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    self.navigationController?.tabBarItem.badgeValue = "!"
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        ref.child("users").child(uid!).child("entertainmentLimit").observe(.value) { (snap) in
            if let value = snap.value as? [String:AnyObject]{
                let progress = value["progress"] as! Double
                let limit = value["limit"] as! Double
                let flag = value["flag"] as! String
                
                if flag == "false"{
                    self.forAddButton()
                } else if flag == "true"{
                    let progressDone = (progress / limit)
                    let percentProgressDone = (progress / limit) * Double(100)
                    
                    self.limitLabel(sizeOfLimit: limit, progressDone: Int(percentProgressDone))
                    self.createProgressView(progress: Float(progressDone))
                    self.forDeleteButton()
                }
            }
        }
    }
    
    //add-button tapped
    @objc func addButtonClicked(_ : UIButton) {
        
        //Add alert for user limit
        let alert = UIAlertController(title: "Set limit", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Limit:"
            textField.keyboardType = .numberPad
        }
        let action = UIAlertAction(title: "Set", style: .default) { (action) in
            
            let limit = Int((alert.textFields?.first!.text)!)
            self.ref.child("users").child(self.uid!).child("entertainmentLimit").setValue(["flag": "true", "limit": limit!, "progress": 0])
            
            self.createProgressView(progress: 0)
            
            //remove add-button from VC
            let subviews = self.view.subviews as [UIView]
            for v in subviews {
                if let button = v as? UIButton{
                    button.removeFromSuperview()
                }
            }
            self.forDeleteButton()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    //delete-button tapped
    @objc func deleteButtonClicked(_: UIButton){
        
        let alert = UIAlertController(title: "Delete limit", message: "Are you shure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            let subviews = self.view.subviews as [UIView]
            for v in subviews {
                if let button = v as? UIButton{
                    button.removeFromSuperview()
                } else if let label = v as? UILabel{
                    label.removeFromSuperview()
                } else if let progress = v as? UIProgressView{
                    progress.removeFromSuperview()
                }
            }
            self.forAddButton()
            self.ref.child("users").child(self.uid!).child("entertainmentLimit").setValue(["flag": "false", "limit": 0, "progress": 0])
            self.navigationController?.tabBarItem.badgeValue = nil
            self.createPageTitle()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    