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
        
        let navigator = parent as! PieraNavigationController
        self.requirementsTable.register(UITableViewCell.self, forCellReuseIdentifier: "RequirementCell")

        requirementStore = RequirementStore()
        requirementsTable.delegate = self
        requirementsTable.dataSource = self
        
        experimentTimeLabel.text = "Time required: \(timeStepper.value) min. (\(timeStepper.value.truncatingRemainder(dividingBy: 30.0) * (navigator.currentAdministration!.perTime) + navigator.currentAdministration!.perTime) Cr.)"
        participantField.keyboardType = UIKeyboardType.numberPad
        descript.textColor = UIColor.lightGray
        objective.textColor = UIColor.lightGray
    }
    
    @IBAction func finishedCreation(){
        guard nameField.text! != "" || locationField.text! != "" || participantField.text! != "" else{
            let alert = UIAlertController(title: "Creation failed", message: "Must fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let navigator = parent as! PieraNavigationController
        // Remove nil coallescor?
        var date = timePicker.date as NSDate
        let timeInterval = floor(date .timeIntervalSinceReferenceDate / 60.0) * 60.0
        date = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        let newExperiment = Experiment(name: nameField.text!, time: date, location: locationField.text!, descript: descript.text!, objective: objective.text!, author: "\((navigator.currentPerson?.name)!) (\(navigator.currentPerson?.email))" , authorID: (navigator.currentPerson?.personID)!, completionTime: timeStepper.value, requirements: requirementStore.allRequirements, maxParticipants: Int(participantField.text!) ?? 100, experimentID: 0)
        guard navigator.server.createExperiment(exp: newExperiment) != nil else {
            let alert = UIAlertController(title: "Creating experiment failed.", message: "Check your internet connection and try again later.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        navigator.addItem(TodoItem(deadline: newExperiment.time!.addingTimeInterval(TimeInterval(-604800)) as Date, title: "in one week", UUID: UUID().uuidString, expName: newExperiment.name, location: newExperiment.location!))
        navigator.addItem(TodoItem(deadline: newExperiment.time!.addingTimeInterval(TimeInterval(-172800)) as Date, title: "in two days", UUID: UUID().uuidString, expName: newExperiment.name, location: newExperiment.location!))
        navigator.addItem(TodoItem(deadline: newExperiment.time!.addingTimeInterval(TimeInterval(-86400)) as Date, title: "in one days", UUID: UUID().uuidString, expName: newExperiment.name, location: newExperiment.location!))
        navigator.addItem(TodoItem(deadline: newExperiment.time!.addingTimeInterval(TimeInterval(-21600)) as Date, title: "in six hours", UUID: UUID().uuidString, expName: newExperiment.name, location: newExperiment.location!))
        navigator.addItem(TodoItem(deadline: newExperiment.time!.addingTimeInterval(TimeInterval(-3600)) as Date, title: "in one hours", UUID: UUID().uuidString, expName: newExperiment.name, location: newExperiment.location!))
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func changeTime(sender: UIStepper){
        let navigator = parent as! PieraNavigationController
        experimentTimeLabel.text = "Time required: \(sender.value) min. (\(Double((Int(sender.value-1.0) / 30)) * (navigator.currentAdministration!.perTime) + navigator.currentAdministration!.perTime) Cr.)"
    }
    
}
