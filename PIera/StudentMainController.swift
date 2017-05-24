import UIKit

class StudentMainController: UIViewController{
    
    @IBOutlet var nameLabel: UILabel!    
    @IBOutlet var creditsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = !navigator.debugMode
        let student = navigator.currentPerson! as! Student
        nameLabel.text = "User: \(student.name)"
        creditsLabel.text = "Credits: \(student.grade) Cr. out of \(navigator.required)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = false
        
        if segue.identifier == "StudentCurrent" {
            let experimentsTable = segue.destination as! ExperimentsViewController
            experimentsTable.relevantExperiments = navigator.server.getStudentExperiments(studentId: navigator.currentPerson!.personID) ?? [Experiment]()
        }
        
        if segue.identifier == "StudentHistory" {
            let experimentsTable = segue.destination as! ExperimentsViewController
            var experiments = [Experiment]()
            if let history = navigator.server.getStudentHistory(studentId: navigator.currentPerson!.personID) {
                for exp in history.keys {
                    exp.grade = history[exp]
                    experiments.append(exp)
                }
            }
            experimentsTable.relevantExperiments = experiments
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
        return experiments.filter{($0.time.compare(Date())) == comparisonType}
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
        return navigator.server.searchForExperiment(studentId: currentStudent.personID)
    }
}
