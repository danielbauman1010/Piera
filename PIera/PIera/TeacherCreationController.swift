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
        let newTeacher = Teacher(name: nameField.text!, password: passwordField.text!, email: emailField.text!, classes: classesField.text!, bio: bio.text!)
        let navigator = parent as! PieraNavigationController
        navigator.teachers.append(newTeacher)
        navigator.currentPerson = newTeacher
        let response = navigator.server.createUser(username: newTeacher.name, email: newTeacher.email, password: newTeacher.password, classes: classesField.text!, bio: newTeacher.bio, type: .Teacher)
    }
}
