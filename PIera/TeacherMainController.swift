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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = false
        if segue.identifier == "TeacherCurrent" || segue.identifier == "TeacherGradable" || segue.identifier == "TeacherHistory"{
            let experimentsTable = segue.destination as! ExperimentsViewController
            if segue.identifier == "TeacherCurrent"{
                experimentsTable.relevantExperiments = navigator.server.getTeacherExperiments(author: navigator.currentPerson! as! Teacher) ?? [Experiment]()
                experimentsTable.relevantExperiments = filterTime(experimentsTable.relevantExperiments, comparisonType: .orderedDescending)
                experimentsTable.relevantExperiments.forEach{$0.gradable=false}
            }
            if segue.identifier == "TeacherGradable"{
                experimentsTable.relevantExperiments = navigator.server.getTeacherExperiments(author: navigator.currentPerson! as! Teacher) ?? [Experiment]()
                experimentsTable.relevantExperiments = filterTime(experimentsTable.relevantExperiments, comparisonType: .orderedAscending)
                experimentsTable.relevantExperiments.forEach{$0.gradable=true}
            }
            if segue.identifier == "TeacherHistory"{
                experimentsTable.relevantExperiments = navigator.server.getTeacherHistory(author: navigator.currentPerson! as! Teacher) ?? [Experiment]()
                experimentsTable.relevantExperiments = filterTime(experimentsTable.relevantExperiments, comparisonType: .orderedAscending)
                experimentsTable.relevantExperiments.forEach{$0.gradable=false}
            }
        }
        if(segue.identifier == "showTeacherMessages") {
            let messagesViewController = segue.destination as! MessagesViewController
            let messages = navigator.server.getMessages(userId: navigator.currentPerson!.personID)
            messagesViewController.messages = messages
        }
        if(segue.identifier == "TeacherLogout"){
            navigator.currentPerson = nil
        }
    }
    
    //Replace and reorganize
    func filterTime(_ experiments: [Experiment], comparisonType: ComparisonResult)->[Experiment]{
        //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
        return experiments.filter{($0.time.compare(Date())) == comparisonType}
    }
}
