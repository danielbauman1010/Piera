import UIKit

class StudentLoginController: UIViewController{
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func attemptLogin(){
        let navigator = parent as! PieraNavigationController
        let response = navigator.server.loginStudent(email: emailField.text!, password: passwordField.text!)
        guard let s = response else {
            let alert = UIAlertController(title: "Login failed", message: "Username or Password not valid.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        navigator.currentPerson = s
        performSegue(withIdentifier: "StudentLoginComplete", sender: nil)
    }
}
