import UIKit

class InitialViewController: UIViewController{
    @IBOutlet weak var ucodeTextField: UITextField!
    
    @IBAction func checkCode(){
        let navigator = parent as! PieraNavigationController
        if let code = ucodeTextField.text {
            navigator.ucode = code
        } else {
            let alert = UIAlertController(title: "Not a valid Piera code", message: "Make sure that you entered the right code", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        performSegue(withIdentifier: "ProperUcode", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = true
        ucodeTextField.text = ""
        navigator.ucode = ""
    }
}
