import UIKit

class DetailedFilterViewController: UIViewController {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var cafeLabel: UILabel!
    @IBOutlet weak var entertainmentLabel: UILabel!
    @IBOutlet weak var supermarketsLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!

    var startValue: String!
    var stopValue: String!
    var expenseValue: String!
    var incomeValue: String!
    var carValue: String!
    var cafeValue: String!
    var entertainmentValue: String!
    var supermarketsValue: String!
    var otherValue: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateLabel.text = startValue
        endDateLabel.text = stopValue
        expenseLabel.text = expenseValue
        incomeLabel.text = incomeValue
        carLabel.text = carValue
        cafeLabel.text = cafeValue
        entertainmentLabel.text = entertainmentValue
        supermarketsLabel.text = supermarketsValue
        otherLabel.text = otherValue
        
    }

}
