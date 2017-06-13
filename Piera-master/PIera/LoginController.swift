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
        switch(navigator.ucodeType){
        case .Student:
            let response = navigator.server.loginStudent(email: emailField.text!, password: passwordField.text!)
            guard let s = response else {
                errorMessage()
                return
            }
            navigator.currentPerson = s
            performSegue(withIdentifier: "StudentLoginComplete", sender: nil)
        case .Teacher:
            let response = navigator.server.loginTeacher(email: emailField.text!, password: passwordField.text!)
            guard let t = response else {
                errorMessage()
                return
            }
            navigator.currentPerson = t
            performSegue(withIdentifier: "TeacherLoginComplete", sender: nil)
        case .Admin:
            //Set to proper admin
            navigator.currentPerson = navigator.administrators.first!
            performSegue(withIdentifier: "AdminLoginComplete", sender: nil)
        default:
            print("error")
        }
    }
    
    func errorMessage(){
        let alert = UIAlertController(title: "Login failed", message: "Username or Password not valid.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
