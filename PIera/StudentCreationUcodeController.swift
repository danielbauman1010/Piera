import UIKit

class StudentCreationUcodeController: UIViewController {

    @IBOutlet weak var ucodeTextField: UITextField!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        if let code = ucodeTextField.text {
            navigator.ucode = code
        }
        
    }
}
