import UIKit

class UniversityCodeController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet weak var codesView: UITextView!
    
    @IBAction func submitName(){
        let navigator = parent as! PieraNavigationController
        let name = nameField.text ?? "Unamed University"
        guard let codes = navigator.server.getUniversityCodes(university: name), let admin = codes["admin"], let teacher = codes["teacher"], let student = codes["student"] else {
            let alert = UIAlertController(title: "Generating codes failed", message: "University already exists.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        codesView.text = "Student Code: \(student)\n\nTeacher Code: \(teacher)\n\nAdministrator Code: \(admin)\n\nWrite these down. They will not be shown again."
    }
    
}
