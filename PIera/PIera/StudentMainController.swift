import UIKit

class StudentMainController: UIViewController{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigator = parent as! PieraNavigationController
        let student = navigator.currentPerson! as! Student
        nameLabel.text = "User: \(student.name)"
        classLabel.text = "Classes: \(student.classes)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        if segue.identifier == "StudentCurrent"{
            let experimentsTable = segue.destination as! ExperimentsViewController
            experimentsTable.relevantExperiments = navigator.experiments.filter{$0.time != "history"}
        }
        if segue.identifier == "StudentHistory"{
            let experimentsTable = segue.destination as! ExperimentsViewController
            experimentsTable.relevantExperiments = navigator.experiments.filter{$0.time == "history"}
        }
    }
}
