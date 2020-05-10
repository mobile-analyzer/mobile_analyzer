import UIKit
import Firebase

/// Просмотр затрат в выбранный период времени
class DateFilterViewController: UIViewController {

    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var carExpenseAmount: UILabel!
    @IBOutlet weak var cafeExpenseAmount: UILabel!
    @IBOutlet weak var entertainmentExpenseAmount: UILabel!
    @IBOutlet weak var supermarketsExpenseAmount: UILabel!
    @IBOutlet weak var otherExpenseAmount: UILabel!
    
    @IBOutlet weak var expenseResultLabel: UILabel!
    @IBOutlet weak var incomeResultLabel: UILabel!
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    
    private var datePickerFrom, datePickerTo: UIDatePicker?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    override func viewDidLoad() {

        //Edditing data choosed with pickerView
        datePickerFrom = UIDatePicker()
        datePickerFrom?.timeZone = TimeZone.current
        
        datePickerTo = UIDatePicker()
        datePickerTo?.timeZone = TimeZone.current
        
        datePickerTo?.maximumDate = Date()
        datePickerFrom?.maximumDate = Date()
        
        ref.child("users").child(uid!).child("dateOfRegistration").observe(.value) { (snapshot) in
            let value = snapshot.value as? Double
            let dif3hour: Double = 1000*60*60*3
            let dateOfRegistration : Date = Date(timeIntervalSince1970: (value! + dif3hour)/1000)
            self.datePickerTo?.minimumDate = dateOfRegistration
            self.datePickerFrom?.minimumDate = dateOfRegistration
            
        }
        
        datePickerFrom?.datePickerMode = .date
        datePickerFrom?.addTarget(self, action: #selector(DateFilterViewController.fromDateChanged(datePickerFrom:)), for: .valueChanged)
        
        datePickerTo?.datePickerMode = .date
        datePickerTo?.addTarget(self, action: #selector(DateFilterViewController.toDateChanged(datePickerTo:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateFilterViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        fromDateTextField.inputView = datePickerFrom
        toDateTextField.inputView = datePickerTo
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    /// Выбор начала периода
    /// - Parameter datePickerFrom: выбор даты
    @objc func fromDateChanged(datePickerFrom: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        fromDateTextField.text = dateFormatter.string(from: datePickerFrom.date)
        
//        let seconds = datePickerFrom.date.timeIntervalSince1970
//        let milliseconds = seconds * 1000
//        print(milliseconds)
    }
    /// Выбор конца периода
    /// - Parameter toDateChanged: выбор даты
    @objc func toDateChanged(datePickerTo: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        toDateTextField.text = dateFormatter.string(from: datePickerTo.date)
    }

    
    /// Нажатие на кнопку поиска информации в заданный период времени
    /// - Parameter sender: Any
    @IBAction func showFilteredButtonTapped(_ sender: Any) {
        
        let difHour: Double = (60*60*26)
        let difMinSec: Double = (60*59+59)
        let dif3hour: Double = (60*60*3)
        
        var totalExpense = 0
        var totalIncome = 0
        
        var carTotal = 0
        var cafeTotal = 0
        var entertainmentTotal = 0
        var supermarketsTotal = 0
        var otherTotal = 0
        
        let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
        let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)! + difHour + difMinSec)*1000
        if fromDate > toDate{
            dispalayAlertMessage(userMessage: "Start date greater than end date")
            
        } else if object_getClass(fromDate)?.description() == "NSNull" || object_getClass(toDate)?.description() == "NSNull"{
            dispalayAlertMessage(userMessage: "Please, choose time interval")
        } else{
            //Counting income for choosed date
            ref.child("users").child(uid!).child("income").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String:AnyObject]{
                    let timeValue = value["timestamp"] as! Double
                    
                    if timeValue >= fromDate && timeValue <= toDate{
                        totalIncome += Int(value["amount"] as! Double)
                    }
                }
                self.incomeResultLabel.text = String(totalIncome)
            }
            
            //Counting cost for Cafe
            ref.child("users").child(uid!).child("expense").child("Cafe").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String: Double] {
                    if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                        totalExpense += Int(value["amount"]!)
                        cafeTotal += Int(value["amount"]!)
                    }
                }
            }
            
            //Counting cost for Car
            ref.child("users").child(uid!).child("expense").child("Car").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String: Double] {
                    if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                        totalExpense += Int(value["amount"]!)
                        carTotal += Int(value["amount"]!)
                    }
                }
            }
            
            //Counting cost for Entertainment
            ref.child("users").child(uid!).child("expense").child("Entertainment").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String: Double] {
                    if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                        totalExpense += Int(value["amount"]!)
                        entertainmentTotal += Int(value["amount"]!)
                    }
                }
            }
            
            //Counting cost for Other
            ref.child("users").child(uid!).child("expense").child("Other").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String: Double] {
                    if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                        totalExpense += Int(value["amount"]!)
                        otherTotal += Int(value["amount"]!)
                    }
                }
            }
            
            //Counting cost for Supermarkets
            ref.child("users").child(uid!).child("expense").child("Supermarkets").observe(.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String: Double] {
                    if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                        totalExpense += Int(value["amount"]!)
                        supermarketsTotal += Int(value["amount"]!)
                    }
                }
                self.expenseResultLabel.text = String(totalExpense)
                self.carExpenseAmount.text = String(carTotal)
                self.cafeExpenseAmount.text = String(cafeTotal)
                self.entertainmentExpenseAmount.text = String(entertainmentTotal)
                self.supermarketsExpenseAmount.text = String(supermarketsTotal)
                self.otherExpenseAmount.text = String(otherTotal)
            }
            
            view.endEditing(true)
        }
    }
    /// Выводит системное сообщение пользователю
    /// - Parameter userMessage: текст сообщения
    func dispalayAlertMessage(userMessage:String){
        let errorAlert = UIAlertController(title: "Oops", message: userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
}

