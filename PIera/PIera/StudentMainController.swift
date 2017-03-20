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
        if segue.identifier == "StudentCurrent" || segue.identifier == "StudentHistory"{
            let experimentsTable = segue.destination as! ExperimentsViewController
            experimentsTable.relevantExperiments = navigator.experiments.filter{$0.studentIDs.contains(navigator.currentPerson!.personID)}
            if segue.identifier == "StudentCurrent"{
            navigator.experiments = filterTime(experiments: experimentsTable.relevantExperiments, .orderedDescending)
            }
            if segue.identifier == "StudentHistory"{
                let experimentsTable = segue.destination as! ExperimentsViewController
                navigator.experiments = filterTime(experiments: experimentsTable.relevantExperiments, .orderedAscending)
            }
        }
    }
    
    //Replace and reorganize
    func filterTime(experiments: [Experiment], _ comparisonType: ComparisonResult)->[Experiment]{
        //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
        return experiments.filter{($0.time?.compare(Date())) == comparisonType}
    }
    
    @IBAction func search(){
        let experiment = searchForExperiment()
        if let result = experiment{
            print(result.name)
        }else{
            print("No experiment matches")
        }
    }
    
    func searchForExperiment()->Experiment?{
        let navigator = parent as! PieraNavigationController
        let currentStudent = navigator.currentPerson as! Student
        for experiment in navigator.currentExperiments{
            if(Set(experiment.requirements).isSubset(of: Set(currentStudent.requirements)) && !experiment.studentIDs.contains(currentStudent.personID)){
                if(experiment.studentIDs.count < experiment.maxParticipants){
                    experiment.studentIDs.append(currentStudent.personID)
                    return experiment
                }
            }
        }
        return nil
    }
}
