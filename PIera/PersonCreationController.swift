import UIKit

class PersonCreationController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var emailField: UITextField!

    
    override func viewWillAppear(_ animated: Bool) {
        nameField.text = ""
        passwordField.text = ""
        confirmPasswordField.text = ""
        emailField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func finishedCreation(){
        guard passwordField.text! == confirmPasswordField.text! else{
            let alert = UIAlertController(title: "Creation failed", message: "Confirmed password not the same as wanted password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard nameField.text! != "" || passwordField.text! != "" || emailField.text! != "" else{
            let alert = UIAlertController(title: "Creation failed", message: "Must fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let navigator = parent as! PieraNavigationController
        if let person = navigator.server.createUser(person: Person(name: nameField.text!, password: passwordField.text!, email: emailField.text!, university: "", id: 0), ucode: navigator.ucode) {            
            if let student = person as? Student {
                navigator.currentPerson =  student
                performSegue(withIdentifier: "StudentCreated", sender: nil)
            } else if let teacher = person as? Teacher {
                navigator.currentPerson =  teacher
                performSegue(withIdentifier: "TeacherCreated", sender: nil)
            } else if let admin = person as? Admin {
                navigator.currentPerson = admin
                performSegue(withIdentifier: "AdminCreated", sender: nil)
            }
<<<<<<< HEAD
        } else {
=======
        }else{
>>>>>>> 6f5c3be2d3cff325f23e60802b20e548de8999a5
            errorMessage()
        }
        
    }
    
    func errorMessage(){
        let alert = UIAlertController(title: "Creation failed", message: "Check that all input is valid. Connection to server may be lost.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
