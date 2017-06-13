import UIKit

class ExperimentDetailViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var maxParticipantLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descript: UITextView!
    @IBOutlet var objective: UITextView!
    @IBOutlet var requirementsListView: UITextView!
    @IBOutlet var acceptOrGradeButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var completionTimeLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    var fromExperimentSearch = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var experiment: Experiment! {
        didSet{
            navigationItem.title = experiment.name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewParticipants"{
            let studentTableController = segue.destination as! StudentTableController
            studentTableController.experiment = experiment
        } else if segue.identifier == "StudentMessageTeacher" {
            /*let messageViewController = segue.destination as! MessageViewController
            messageViewController.messageDestination = Teacher(name: self.experiment.author, password: "", email: self.experiment.email, university: "", id: self.experiment.authorID)*/
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func acceptOrGradeExperiment(){
        let navigator = parent as! PieraNavigationController
        if let currentStudent = navigator.currentPerson as? Student?, navigator.server.participateInExperiment(studentId: currentStudent!.personID, experimentId: experiment.experimentID){
            
            //experiment.studentIDs.append(currentStudent!.personID)
            performSegue(withIdentifier: "ExperimentDecisionMade", sender: nil)
        }else{            
            performSegue(withIdentifier: "ViewParticipants", sender: nil)
        }
    }
    
    @IBAction func declineExperiment(){
        performSegue(withIdentifier: "ExperimentDecisionMade", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigator = parent as! PieraNavigationController
        nameLabel.text = experiment.name
        authorLabel.text = "\(experiment.author) (\(experiment.email))"
        maxParticipantLabel.text = "Max Participants: \(experiment.maxParticipants), Current Participants: \(experiment.studentIDs.count)"
        timeLabel.text = "Time: \(dateFormatter.string(from: experiment.time as Date))"
        locationLabel.text = "Location: \(experiment.location)"
        descript.text = "Description:\n\(experiment.descript)"
        objective.text = "Objective:\n\(experiment.objective)"
        completionTimeLabel.text =  "Time required: \(experiment.completionTime) min. (\(experiment.creditValue) Cr.)"
        var requirementsList : String = "Requirements:\n"
        for requirement in experiment.requirements {
            requirementsList += "\(requirement)\n"
        }
        
        requirementsListView.text = requirementsList
        
        if (navigator.currentPerson as? Teacher?) != nil{
            acceptOrGradeButton.setTitle("Participants",for: .normal)
            declineButton.isHidden = true
            messageButton.isHidden = true
        }else if(navigator.currentPerson as? Student? != nil && !fromExperimentSearch){
            acceptOrGradeButton.isHidden = true
            declineButton.isHidden = true
        }
    }
    
}
