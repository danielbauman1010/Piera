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
        navigator.students.append(newStudent)
        navigator.currentPerson = newStudent
        let response = navigator.server.createUser(username: newStudent.name, email: newStudent.email, password: newStudent.password, classes: classesField.text!, bio: newStudent.bio, type: .Student)
    }
}
