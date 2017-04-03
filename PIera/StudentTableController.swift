import UIKit

class StudentTableController: UITableViewController{
    var students = [Student]()
    
    var experiment: Experiment! {
        didSet{
            navigationItem.title = experiment.name
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        //requirementStore = RequirementStore()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
        
        cell.updateLabels()
        
        let student = students[indexPath.row]
        
        cell.nameLabel.text = student.name
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        update()
    }
    
    func update(){
        let navigator = parent as! PieraNavigationController
        let relevantStudents = navigator.students.filter{experiment.studentIDs.contains($0.personID)}
        for student in relevantStudents{
            students.append(student)
        }
    }
}
