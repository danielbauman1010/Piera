import UIKit

class ExperimentDetailViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descript: UITextView!
    @IBOutlet var objective: UITextView!
    
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
        timeLabel.text = "Time: \(experiment.time!)"
        locationLabel.text = "Location: \(experiment.location!)"
        descript.text = "Description:\n\(experiment.descript!)"
        objective.text = "Objective:\n\(experiment.objective!)"
    }
    
}
