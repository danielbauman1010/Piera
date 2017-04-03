import UIKit

class RequirementTableController: UITableViewController{
    var hasLeftRequirements = false
    
    var activeRequirements = [String]()
    let sections = ["Unmet Requirements", "Met Requirements"]
    
    var requirementsData: Dictionary<Int, RequirementStore> = [
        0 : RequirementStore(),
        1 : RequirementStore()
    ]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requirementsData[section]!.allRequirements.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return sections[section]
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        //requirementStore = RequirementStore()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequirementCell", for: indexPath) as! RequirementCell
        
        cell.updateLabels()
        
        let requirement = requirementsData[indexPath.section]!.allRequirements[indexPath.row]
        
        cell.requirementLabel.text = requirement
        if(indexPath.section == 1){ cell.requirementSwitch.isOn = true }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        requirementsData[sourceIndexPath.section]!.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishRequirements"{
            let navigator = parent as! PieraNavigationController
            let currentStudent = navigator.currentPerson as! Student
            for cell in tableView.visibleCells as! [RequirementCell]{
                let index = tableView.indexPath(for: cell)!
                if(index.section == 0 && cell.requirementSwitch.isOn){
                    currentStudent.requirements.append(cell.requirementLabel.text!)
                }
                if(index.section == 1 && !cell.requirementSwitch.isOn){                    currentStudent.requirements = currentStudent.requirements.filter{cell.requirementLabel!.text! != $0}
                }
            }
            hasLeftRequirements = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if(!hasLeftRequirements){ update() }
    }
    
    func update(){
        let navigator = parent as! PieraNavigationController
        let currentStudent = navigator.currentPerson as! Student
        for experiment in navigator.currentExperiments{
            activeRequirements.append(contentsOf: experiment.requirements)
        }
        activeRequirements = activeRequirements.filter{!currentStudent.requirements.contains($0)}
        let activeRequirementsSet = Set(activeRequirements)
        for requirement in activeRequirementsSet{
            requirementsData[0]!.allRequirements.append(requirement)
            
            if let index = requirementsData[0]!.allRequirements.index(of: requirement){
                let indexPath = IndexPath(row: index, section: 0)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        for requirement in currentStudent.requirements{
            requirementsData[1]!.allRequirements.append(requirement)
            
            if let index = requirementsData[1]!.allRequirements.index(of: requirement){
                let indexPath = IndexPath(row: index, section: 1)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
