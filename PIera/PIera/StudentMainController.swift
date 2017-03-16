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
            navigator.experiments = filterTime(experiments: experimentsTable.relevantExperiments, .orderedDescending)
        }
        if segue.identifier == "StudentHistory"{
            let experimentsTable = segue.destination as! ExperimentsViewController
            navigator.experiments = filterTime(experiments: experimentsTable.relevantExperiments, .orderedAscending)
        }
    }
    
    func filterTime(experiments: [Experiment], _ comparisonType: ComparisonResult)->[Experiment]{
        //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
        return experiments.filter{($0.time?.compare(Date())) == comparisonType}
    }
}
