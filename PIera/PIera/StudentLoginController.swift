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
        let response = navigator.server.login(email: emailField.text!, password: passwordField.text!)
        print("\n\nresponse to login:\n\(response)\n\n")
        guard let r = response, r["loginStatus"]=="1" else {
            let alert = UIAlertController(title: "Login failed", message: "Username or Password not valid.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        var classes = ""
        for k in r.keys {
            if k.contains("class") {
                classes += r[k]!
            }
        }
        navigator.currentPerson = Student(name: r["username"]!, password: r["password"]!, email: r["email"]!, interests: "", classes: classes, bio: r["bio"]!)
        performSegue(withIdentifier: "StudentLoginComplete", sender: nil)
    }
}
