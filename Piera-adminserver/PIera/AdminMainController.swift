import UIKit

class AdminMainController: UIViewController{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var creditsPerTime: UILabel!
    @IBOutlet var creditsRequired: UILabel!
    @IBOutlet var creditsPenalized: UILabel!
    @IBOutlet var perTimeStepper : UIStepper!
    @IBOutlet var requiredStepper : UIStepper!
    @IBOutlet var penaltyStepper : UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = !navigator.debugMode
        let admin = navigator.currentPerson as! Admin
        
        nameLabel.text = "User: \(admin.name)"
        //Update for administration from server
        perTimeStepper.value = admin.pertime
        requiredStepper.value = admin.required
        penaltyStepper.value = admin.penalty
        creditsPerTime.text = "Credits per half hour: \(perTimeStepper.value)"
        creditsRequired.text = "Credits required: \(requiredStepper.value)"
        creditsPenalized.text = "Penalty for missing exp: \(penaltyStepper.value)"
    }
    
    @IBAction func update(){
        let navigator = parent as! PieraNavigationController
        if navigator.server.updateCredits(userId: navigator.currentPerson!.personID, pertime: perTimeStepper.value, required: requiredStepper.value, penalty: penaltyStepper.value) {
            
        }
    }
    
    @IBAction func creditsPerTimeChanged(){
        creditsPerTime.text = "Credits per half hour: \(perTimeStepper.value)"

    }
    
    @IBAction func creditsRequiredChanged(){
        creditsRequired.text = "Credits required: \(requiredStepper.value)"

    }
    
    @IBAction func creditsPenalizedChanged(){
        creditsPenalized.text = "Penalty for missing exp: \(penaltyStepper.value)"
    }
}
