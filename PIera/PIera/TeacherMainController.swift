import UIKit

class TeacherMainController: UIViewController{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigator = parent as! PieraNavigationController
        let teacher = navigator.currentPerson! as! Teacher
        nameLabel.text = "User: \(teacher.name)"
        classLabel.text = "Classes: \(teacher.classes)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        if segue.identifier == "TeacherCurrent" || segue.identifier == "TeacherGradable" || segue.identifier == "TeacherHistory"{
            let experimentsTable = segue.destination as! ExperimentsViewController
            experimentsTable.relevantExperiments = navigator.experiments.filter{$0.author == navigator.currentPerson?.name}
            if segue.identifier == "TeacherCurrent"{
                experimentsTable.relevantExperiments = (experimentsTable.relevantExperiments.filter{$0.time != "history"}
                                                                        .filter{$0.time != "gradable"}
                                                                        .filter{$0.author == navigator.currentPerson?.name})
            }
            if segue.identifier == "TeacherGradable"{
                let experimentsTable = segue.destination as! ExperimentsViewController
                experimentsTable.relevantExperiments = experimentsTable.relevantExperiments.filter{$0.time == "gradable"}
            }
            if segue.identifier == "TeacherHistory"{
                let experimentsTable = segue.destination as! ExperimentsViewController
                experimentsTable.relevantExperiments = experimentsTable.relevantExperiments.filter{$0.time == "history"}
            }
        }
    }
}
