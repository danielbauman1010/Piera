import UIKit

class InitialViewController: UIViewController{
    @IBOutlet weak var ucodeTextField: UITextField!
    
    @IBAction func checkCode(){
        let navigator = parent as! PieraNavigationController
        if let code = ucodeTextField.text {
            for administration in navigator.administrations{
                switch code{
                case administration.adminCode: navigator.ucodeType = personType.Admin
                    navigator.currentAdministration = administration
                case administration.teacherCode: navigator.ucodeType = personType.Teacher
                    navigator.currentAdministration = administration
                case administration.studentCode: navigator.ucodeType = personType.Student
                    navigator.currentAdministration = administration
                default: continue
                }
            }
            if(navigator.ucodeType != personType.None){
                navigator.ucode = code
                performSegue(withIdentifier: "ProperUcode", sender: nil)
            }else{
                let alert = UIAlertController(title: "Not a valid Piera code", message: "Make sure that you entered the right code", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = true
        navigator.ucodeType = personType.None
        navigator.currentAdministration = nil
    }
}
