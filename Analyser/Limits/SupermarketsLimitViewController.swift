import UIKit
import Firebase
/// Страница с лимитом на супермаркеты
class SupermarketsLimitViewController: UIViewController {

    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createPageTitle()
        
        ref.child("users").child(uid!).child("supermarketsLimit").observe(.value) { (snap) in
            if let value = snap.value as? [String:AnyObject]{
                let progress = value["progress"] as! Double
                let limit = value["limit"] as! Double
                if progress > limit{
                    let alert = UIAlertController(title: nil, message: "Exceeded the limit on the category of supermarkets!", preferredStyle: .alert)
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
        
        ref.child("users").child(uid!).child("supermarketsLimit").observe(.value) { (snap) in
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
    ///Кнопка задания лимита
    @objc func addButtonClicked(_ : UIButton) {
        
        //Add alert for user limit
        let alert = UIAlertController(title: "Set limit", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Limit:"
            textField.keyboardType = .numberPad
        }
        let action = UIAlertAction(title: "Set", style: .default) { (action) in
            
            let limit = Int((alert.textFields?.first!.text)!)
            self.ref.child("users").child(self.uid!).child("supermarketsLimit").setValue(["flag": "true", "limit": limit!, "progress": 0])
            
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
    ///Кнопка удаления лимита
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
            self.ref.child("users").child(self.uid!).child("supermarketsLimit").setValue(["flag": "false", "limit": 0, "progress": 0])
            self.navigationController?.tabBarItem.badgeValue = nil
            self.createPageTitle()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    let x = 0
    let y = 70
    
    
    //setup add limit Button
    func forAddButton(){
        let addButton = UIButton.init(type: .system)
        addButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        addButton.setBackgroundImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(addButton)
    }
    
    //setup delete limit  button
    func forDeleteButton(){
        let deleteButton = UIButton.init(type: .system)
        deleteButton.frame = CGRect(x: 184-x, y: 602-y, width: 50, height: 50)
        deleteButton.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
        self.view.addSubview(deleteButton)
    }
    
    //setup limit lables
    let limitLabel = UILabel.init()
    func limitLabel(sizeOfLimit: Double, progressDone: Any){
        
        limitLabel.frame = CGRect(x: 130-x, y: 490-y, width: 70, height: 21)
        limitLabel.text = "\(progressDone)%"
        limitLabel.textColor = .white
        
        
        let amountOfLimit = UILabel.init()
        amountOfLimit.frame = CGRect(x: 278-x, y: 522-y, width: 250, height: 23)
        amountOfLimit.text = "\(sizeOfLimit)"
        amountOfLimit.textColor = .white
        amountOfLimit.font = .systemFont(ofSize: 25)

        self.view.addSubview(limitLabel)
        self.view.addSubview(amountOfLimit)
    }
    
    //setup progress view
    func createProgressView(progress: Float){
        let progressView = UIProgressView.init()
        progressView.frame = CGRect(x: 20-x, y: 531-y, width: 250, height: 1)
        progressView.setProgress(progress, animated: true)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        progressView.progressTintColor = .red
        self.view.addSubview(progressView)
    }
    
    //setup page title
    func createPageTitle(){
        let pageTitle = UILabel.init()
        pageTitle.frame = CGRect(x: 0, y: 0, width: 271, height: 50)
        pageTitle.center = CGPoint(x: view.frame.width / 2, y: 20)
        pageTitle.text = "Supermarkets limit"
        pageTitle.textColor = .white
        pageTitle.font = .systemFont(ofSize: 33)
        self.view.addSubview(pageTitle)
    }
}
