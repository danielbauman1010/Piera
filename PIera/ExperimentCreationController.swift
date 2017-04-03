import UIKit

class ExperimentCreationController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var locationField: UITextField!
    @IBOutlet var participantField: UITextField!
    @IBOutlet var experimentTimeLabel : UILabel!
    @IBOutlet var timeStepper: UIStepper!
    @IBOutlet var objective: UITextView!
    @IBOutlet var descript: UITextView!
    @IBOutlet var requirementField: UITextField!
    @IBOutlet var requirementsTable: UITableView!
    
    var requirementStore: RequirementStore!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requirementsTable.register(UITableViewCell.self, forCellReuseIdentifier: "RequirementCell")

        requirementStore = RequirementStore()
        requirementsTable.delegate = self
        requirementsTable.dataSource = self
        
        experimentTimeLabel.text = "Time required: \(timeStepper.value) min. (\(timeStepper.value.truncatingRemainder(dividingBy: 30.0) + 1.0) Cr.)"
    }
    
    @IBAction func finishedCreation(){
        let navigator = parent as! PieraNavigationController
        // Remove nil coallescor?
        let newExperiment = Experiment(name: nameField.text!, time: timePicker.date as NSDate?, location: locationField.text!, descript: descript.text!, objective: objective.text!, author: (navigator.currentPerson?.name)!, authorID: (navigator.currentPerson?.personID)!, completionTime: timeStepper.value, requirements: requirementStore.allRequirements, maxParticipants: Int(participantField.text!) ?? 100)
        navigator.experiments.append(newExperiment)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requirementStore.allRequirements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RequirementCell")! as UITableViewCell
        
        let requirement = self.requirementStore.allRequirements[indexPath.row]
        
        cell.textLabel?.text = requirement
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        requirementStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let item = requirementStore.allRequirements[indexPath.row]
            requirementStore.removeItem(item)
            requirementsTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func createNew(){
        let newRequirement = requirementStore.createRequirement(requirementField.text!)
        
        if let index = requirementStore.allRequirements.index(of: newRequirement){
            let indexPath = IndexPath(row: index, section: 0)
            
            requirementsTable.insertRows(at: [indexPath], with: .automatic)
        }
        requirementField.text = ""
        self.requirementsTable.reloadData()
    }
    
    @IBAction func toggleEditting(){
        requirementsTable.isEditing ? requirementsTable.setEditing(false, animated: true) : requirementsTable.setEditing(true, animated: true)
    }
    
    @IBAction func changeTime(sender: UIStepper){
        experimentTimeLabel.text = "Time required: \(sender.value) min. (\(Double((Int(sender.value-1.0) / 30)) + 1.0) Cr.)"
    }
    
}
