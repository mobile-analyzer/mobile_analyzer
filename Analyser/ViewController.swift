import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension Int {
    func square() -> Int {
        return self * self * self
    }
}

extension String {
    func title() -> String {
        return self + "limit"
    }
}
