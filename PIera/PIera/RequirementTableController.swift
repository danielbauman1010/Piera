import UIKit

class RequirementTableController: UITableViewController{
    
    var requirementStore: RequirementStore!
    var activeRequirements = [String]()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requirementStore.allRequirements.count
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        requirementStore = RequirementStore()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequirementCell", for: indexPath) as! RequirementCell
        
        cell.updateLabels()
        
        let requirement = requirementStore.allRequirements[indexPath.row]
        
        cell.requirementLabel.text = requirement
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        requirementStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishRequirements"{
            let navigator = parent as! PieraNavigationController
            for cell in tableView.visibleCells as! [RequirementCell]{
                if(cell.requirementSwitch.isOn){
                    let currentStudent = navigator.currentPerson as! Student
                    currentStudent.requirements.append(cell.requirementLabel.text!)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        update()
    }
    
    func update(){
        let navigator = parent as! PieraNavigationController
        for experiment in navigator.currentExperiments{
            activeRequirements.append(contentsOf: experiment.requirements)
        }
        for requirement in activeRequirements{
            requirementStore.allRequirements.append(requirement)
            
            if let index = requirementStore.allRequirements.index(of: requirement){
                let indexPath = IndexPath(row: index, section: 0)
                
                //Problem
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
