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
        let newStudent = Student(name: nameField.text!, password: passwordField.text!, email: emailField.text!, interests: interestsField.text!, classes: classesField.text!, bio: bio.text!)
        let navigator = parent as! PieraNavigationController
        let response = navigator.server.createUser(username: newStudent.name, email: newStudent.email, password: newStudent.password, classes: classesField.text!, bio: newStudent.bio, type: .Student)
        print("\n\nresponse(in creation)\n\(response)\n\n\n")
        guard let r = response else {
            let alert = UIAlertController(title: "Login failed", message: "Error creating new student.", preferredStyle: UIAlertControllerStyle.alert)
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
        
    }
}
