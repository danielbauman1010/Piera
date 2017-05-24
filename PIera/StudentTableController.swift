import UIKit

class StudentTableController: UITableViewController{
    @IBOutlet var gradeButton: UIBarButtonItem!
    
    var students = [Student]()
    var gradable: Bool = true
    
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
        
        cell.updateLabels()
        
        let student = students[indexPath.row]
        
        cell.nameLabel.text = "\(student.name) (\(student.email))"
        
        if(!gradable){
            cell.gradingSwitch.onTintColor = UIColor.gray
            cell.gradingSwitch.isUserInteractionEnabled = false
        }else{
            cell.gradingSwitch.onTintColor = UIColor.green
            cell.gradingSwitch.isUserInteractionEnabled = true
        }
        
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
        let relevantStudents = experiment.studentIDs.map{navigator.server.getStudent(studentId: $0)!}
        if(navigator.currentExperiments.contains(experiment)){
            gradable = false
            gradeButton.title! = "Cannot grade. Experiment still active."
        }else if(experiment.graded){
            gradable = false
            gradeButton.title! = "Re-open experiment."
        }else{
            gradable = true
            gradeButton.title! = "Grade"
        }
        students = [Student]()
        for student in relevantStudents{
            students.append(student)
        }
    }
    
    @IBAction func grade(){
        let navigator = parent as! PieraNavigationController
        if gradable{
            for cell in tableView.visibleCells as! [StudentCell]{
                let index = tableView.indexPath(for: cell)!
                if(cell.gradingSwitch.isOn){
                    if navigator.server.gradeStudent(studentId: students[index.row].personID, experimentId: experiment.experimentID, grade: experiment.creditValue) == false{
                        
                    }
                }
                cell.gradingSwitch.onTintColor = UIColor.gray
                cell.gradingSwitch.isUserInteractionEnabled = false
            }
            gradeButton.title! = "Re-open experiment."
            experiment.graded = true
            gradable = false
        }
    }
}
