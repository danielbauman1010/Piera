import UIKit

class TeacherCreationController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var classesField: UITextField!
    @IBOutlet var bio: UITextView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func finishedCreation(){
        let classes = classesField.text!
        let classesArray = classes.components(separatedBy: " ")
        let newTeacher = Teacher(name: nameField.text!, password: passwordField.text!, email: emailField.text!, classes: classesArray, bio: bio.text!)
        let navigator = parent as! PieraNavigationController
        navigator.teachers.append(newTeacher)
        navigator.currentPerson = newTeacher
        navigator.server.createUser(username: nameField.text!, email: emailField.text!, password: passwordField.text!, classes: classesArray, bio: bio.text!, type: .Teacher)
    }
}
