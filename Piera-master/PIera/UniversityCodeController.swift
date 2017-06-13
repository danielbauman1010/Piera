import UIKit

class UniversityCodeController: UIViewController{
    @IBOutlet var adminCode: UILabel!
    @IBOutlet var teacherCode: UILabel!
    @IBOutlet var studentCode: UILabel!
    @IBOutlet var nameField: UITextField!
    
    @IBAction func submitName(){
        let navigator = parent as! PieraNavigationController
        
        let admin = randomString(6)
        let teacher = randomString(6)
        let student = randomString(6)
        adminCode?.text = "Administrator Code: \(admin)"
        teacherCode?.text = "Teacher Code: \(teacher)"
        studentCode?.text = "Student Code: \(student)"
        navigator.administrations.append(Administration(name: nameField.text!, studentCode: student, teacherCode: teacher, adminCode: admin))
    }
    
    func randomString(_ length: Int) -> String {
        //let navigator = parent as! PieraNavigationController
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        //if("String not already a university code"){
        return randomString
        //}
    }
}
