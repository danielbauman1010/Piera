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
        let navigator = parent as! PieraNavigationController
        if let person = navigator.server.createUser(person: Person(name: nameField.text!, password: passwordField.text!, email: emailField.text!, university: "", id: 0), ucode: navigator.ucode) {
            if let creditSystem = navigator.server.getCredits(university: person.university) {
                navigator.perTime = creditSystem["pertime"]!
                navigator.penalty = creditSystem["penalty"]!
                navigator.required = creditSystem["required"]!
            }
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
        }

    }
    
    func errorMessage(){
        let alert = UIAlertController(title: "Creation failed", message: "Error connecting to server, please check your internet connection and try again later.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
