import UIKit

class StudentTableController: UITableViewController{
    @IBOutlet var gradeButton: UIBarButtonItem!
    
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
        
        cell.updateLabels()
        
        let student = students[indexPath.row]
        
        cell.nameLabel.text = "\(student.name) (\(student.email))"
        
        if(!experiment.gradable){
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
        if(experiment.gradable){
            gradeButton.title! = "Grade"
            gradeButton.isEnabled = true
        }else{
            gradeButton.title! = "Experiment closed."
            gradeButton.isEnabled = false
        }
        students = [Student]()
        for student in relevantStudents{
            students.append(student)
        }
    }
    
    
    
    @IBAction func grade(){
        let navigator = parent as! PieraNavigationController
        var studentIds = [Int: Bool]()
        print("grade function called")
        if experiment.gradable{
            print("experiment gradable")
            for cell in tableView.visibleCells as! [StudentCell]{
                let index = tableView.indexPath(for: cell)!
                print("\(students[index.row].personID) : \(cell.gradingSwitch.isOn)")
                studentIds[students[index.row].personID] = cell.gradingSwitch.isOn
                cell.gradingSwitch.onTintColor = UIColor.gray
                cell.gradingSwitch.isUserInteractionEnabled = false
            }
            gradeButton.title! = "Re-open experiment."
            experiment.graded = true
            experiment.gradable = false
            if navigator.server.gradeStudents(studentIds: studentIds, experimentId: experiment.experimentID) == false{
                print("error grading")
            }
        }
    }
}
