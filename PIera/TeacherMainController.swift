import UIKit

class TeacherMainController: UIViewController{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigator = parent as! PieraNavigationController
        let teacher = navigator.currentPerson! as! Teacher
        navigator.navigationBar.isHidden = !navigator.debugMode
        nameLabel.text = "User: \(teacher.name)"
        classLabel.text = "Classes: \(teacher.classes)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        if segue.identifier == "TeacherCurrent" || segue.identifier == "TeacherGradable" || segue.identifier == "TeacherHistory"{
            navigator.navigationBar.isHidden = false
            let experimentsTable = segue.destination as! ExperimentsViewController
            let exps = navigator.server.getTeacherExperiments(author: navigator.currentPerson! as! Teacher) ?? [Experiment]()
            experimentsTable.relevantExperiments = exps
        }
        if(segue.identifier == "TeacherLogout"){
            navigator.currentPerson = nil
        }
    }
    
    //Replace and reorganize
    func filterTime(_ experiments: [Experiment], comparisonType: ComparisonResult)->[Experiment]{
        //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
        return experiments.filter{($0.time?.compare(Date())) == comparisonType}
    }
}
