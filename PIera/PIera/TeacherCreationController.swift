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
        let response = navigator.server.createUser(username: newTeacher.name, email: newTeacher.email, password: newTeacher.password, classes: classesField.text!, bio: newTeacher.bio, type: .Teacher)
        print("\n\nresponse(in creation)\n\(response)\n\n\n")
        guard let r = response else {
            let alert = UIAlertController(title: "Login failed", message: "Error creating new teacher.", preferredStyle: UIAlertControllerStyle.alert)
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
        navigator.currentPerson = Teacher(name: r["username"]!, password: r["password"]!, email: r["email"]!, classes: classes, bio: r["bio"]!)
        
    }
}
