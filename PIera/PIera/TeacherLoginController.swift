import UIKit

class TeacherLoginController: UIViewController{
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func attemptLogin(){
        let navigator = parent as! PieraNavigationController
        for teacher in navigator.teachers{
            if (teacher.email == emailField.text!) && (teacher.password == passwordField.text!){
                navigator.currentPerson = teacher
                performSegue(withIdentifier: "TeacherLoginComplete", sender: nil)
            }
        }
    }
}
