import UIKit

class ExperimentCreationController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var timeField: UITextField!
    @IBOutlet var locationField: UITextField!
    @IBOutlet var participantField: UITextField!
    @IBOutlet var objective: UITextView!
    @IBOutlet var descript: UITextView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func finishedCreation(){
        let newExperiment = Experiment(name: nameField.text!, time: timeField.text!, location: locationField.text!, descript: descript.text!, objective: objective.text!)
        let navigator = parent as! PieraNavigationController
        navigator.experiments.append(newExperiment)
    }
}
