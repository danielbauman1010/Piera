import UIKit

class PersonCreationController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var classesField: UITextField!
    @IBOutlet var classesLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let navigator = parent as! PieraNavigationController
        switch (navigator.ucodeType){
            case .Student: classesLabel.text! = "Classes you enroll:"
            default: classesLabel.text! = "Classes you teach:"
        }
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
        switch(navigator.ucodeType){
        case .Student:
            let tryStudent = Student(name: nameField.text!, password: passwordField.text!, email: emailField.text!, classes: classesField.text!, id: 0)
            guard let s = navigator.server.createStudent(student: tryStudent, ucode: navigator.ucode) else {
                errorMessage()
                return
            }
            navigator.currentPerson =  s
            performSegue(withIdentifier: "StudentCreated", sender: nil)
        case.Teacher:
            let tryTeacher = Teacher(name: nameField.text!, password: passwordField.text!, email: emailField.text!, classes: classesField.text!, id: 0)
            guard let t = navigator.server.createTeacher(teacher: tryTeacher, ucode: navigator.ucode) else {
                errorMessage()
                return
            }
            navigator.currentPerson =  t
            performSegue(withIdentifier: "TeacherCreated", sender: nil)
        case .Admin:
            let a = Person(name: nameField.text!, password: passwordField.text!, email: emailField.text!, id: 0)
            navigator.administrators.append(a)
            navigator.currentPerson = a
            performSegue(withIdentifier: "AdminCreated", sender: nil)
        default:
            print("error")
        }
    }
    
    func errorMessage(){
        let alert = UIAlertController(title: "Creation failed", message: "Error connecting to server, please check your internet connection and try again later.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
