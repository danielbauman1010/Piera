import UIKit

class LoginController: UIViewController{
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func attemptLogin(){
        let navigator = parent as! PieraNavigationController        
        if let person = navigator.server.login(email: emailField.text!, password: passwordField.text!, ucode: navigator.ucode) {
            if let student = person as? Student {
                navigator.currentPerson = student
                performSegue(withIdentifier: "StudentLoginComplete", sender: nil)
            } else if let teacher = person as? Teacher {
                navigator.currentPerson =  teacher
                performSegue(withIdentifier: "TeacherLoginComplete", sender: nil)
            } else if let admin = person as? Admin {
                navigator.currentPerson = admin
                performSegue(withIdentifier: "AdminLoginComplete", sender: nil)
            }
        } else {
            errorMessage()
        }
    }
    
    func errorMessage(){
        let alert = UIAlertController(title: "Login failed", message: "Username or Password not valid. (If error repeats, check your internet connection)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
