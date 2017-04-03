import UIKit

class StudentMainController: UIViewController{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var creditsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = !navigator.debugMode
        let student = navigator.currentPerson! as! Student
        nameLabel.text = "User: \(student.name)"
        classLabel.text = "Classes: \(student.classes)"
        creditsLabel.text = "Credits: \(student.credits)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        if segue.identifier == "StudentCurrent" || segue.identifier == "StudentHistory"{
            navigator.navigationBar.isHidden = false
            let experimentsTable = segue.destination as! ExperimentsViewController
            experimentsTable.relevantExperiments = navigator.experiments.filter{$0.studentIDs.contains(navigator.currentPerson!.personID)}
            if segue.identifier == "StudentCurrent"{
                experimentsTable.relevantExperiments = filterTime(experiments: experimentsTable.relevantExperiments, .orderedDescending)
            }
            if segue.identifier == "StudentHistory"{
                experimentsTable.relevantExperiments = filterTime(experiments: experimentsTable.relevantExperiments, .orderedAscending)
            }
        }
        if segue.identifier == "ExperimentFound"{
            let detailViewController = segue.destination as! ExperimentDetailViewController
            detailViewController.experiment = sender as! Experiment!
            detailViewController.fromExperimentSearch = true
        }
        if(segue.identifier == "StudentLogout"){
            navigator.currentPerson = nil
        }
    }
    
    //Replace and reorganize
    func filterTime(experiments: [Experiment], _ comparisonType: ComparisonResult)->[Experiment]{
        //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
        return experiments.filter{($0.time?.compare(Date())) == comparisonType}
    }
    
    //sender = experiment? No problems so far.
    @IBAction func search(){
        let experiment = searchForExperiment()
        if let result = experiment{
            print(result.name)
            performSegue(withIdentifier: "ExperimentFound", sender: experiment)
        }else{
            let alert = UIAlertController(title: "No Experiment Found", message: "Update your requirements or wait for a new experiment to open", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchForExperiment()->Experiment?{
        let navigator = parent as! PieraNavigationController
        let currentStudent = navigator.currentPerson as! Student
        for experiment in navigator.currentExperiments{
            if(Set(experiment.requirements).isSubset(of: Set(currentStudent.requirements)) && !experiment.studentIDs.contains(currentStudent.personID)){
                if(experiment.studentIDs.count < experiment.maxParticipants){
                    return experiment
                }
            }
        }
        return nil
    }
}
