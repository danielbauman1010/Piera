import UIKit

class ExperimentDetailViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var maxParticipantLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descript: UITextView!
    @IBOutlet var objective: UITextView!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var experiment: Experiment! {
        didSet{
            navigationItem.title = experiment.name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = experiment.name
        authorLabel.text = experiment.author
        maxParticipantLabel.text = "Max Participants: \(experiment.maxParticipants), Current Participants: \(experiment.studentIDs.count)"
        timeLabel.text = "Time: \(dateFormatter.string(from: experiment.time! as Date))"
        locationLabel.text = "Location: \(experiment.location!)"
        descript.text = "Description:\n\(experiment.descript!)"
        objective.text = "Objective:\n\(experiment.objective!)"
    }
    
}
