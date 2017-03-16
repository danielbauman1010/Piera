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
        for student in navigator.students{
            if (student.email == emailField.text!) && (student.password == passwordField.text!){
                navigator.currentPerson = student
                performSegue(withIdentifier: "StudentLoginComplete", sender: nil)
            }
        }
    }
}
