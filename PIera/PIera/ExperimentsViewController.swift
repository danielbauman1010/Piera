import UIKit

class ExperimentsViewController: UITableViewController{
    
    var experimentStore: ExperimentStore!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experimentStore.allExperiments.count
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        experimentStore = ExperimentStore()
        
        //navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperimentCell", for: indexPath) as! ExperimentCell
        
        cell.updateLabels()
        
        let experiment = experimentStore.allExperiments[indexPath.row]
        
        cell.nameLabel.text = experiment.name
        cell.timeLabel.text = experiment.time
        cell.locationLabel.text = experiment.location
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let experiment = experimentStore.allExperiments[indexPath.row]
            
            let title = "Delete \(experiment.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            experimentStore.removeItem(experiment)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                             handler: { (action) -> Void in
                                                self.experimentStore.removeItem(experiment)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        experimentStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExperiment"{
            if let row = tableView.indexPathForSelectedRow?.row{
                let experiment = experimentStore.allExperiments[row]
                let detailViewController = segue.destination as! ExperimentDetailViewController
                detailViewController.experiment = experiment
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
        for experiment in navigator.experiments{
            experimentStore.allExperiments.append(experiment)
            
            if let index = experimentStore.allExperiments.index(of: experiment){
                let indexPath = IndexPath(row: index, section: 0)
                
                //Problem
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
