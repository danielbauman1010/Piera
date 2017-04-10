import UIKit

class StudentCreationController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var interestsField: UITextField!
    @IBOutlet var classesField: UITextField!
    @IBOutlet var bio: UITextView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func finishedCreation(){
        let navigator = parent as! PieraNavigationController
        let tryStudent = Student(name: nameField.text!, password: passwordField.text!, email: emailField.text!, interests: interestsField.text!, classes: classesField.text!, bio: bio.text, id: 0)
        guard let s = navigator.server.createStudent(student: tryStudent, ucode: navigator.ucode) else {
            let alert = UIAlertController(title: "Creation failed", message: "Wrong university code or error connecting to server, please check your internet connection and try again later.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        navigator.currentPerson =  s
        
    }
}

