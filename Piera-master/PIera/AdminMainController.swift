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
        let admin = navigator.currentPerson!
        
        nameLabel.text = "User: \(admin.name)"
        //Update for administration from server
        perTimeStepper.value = navigator.currentAdministration!.perTime
        requiredStepper.value = navigator.currentAdministration!.required
        penaltyStepper.value = navigator.currentAdministration!.penalty
        creditsPerTime.text = "Credits per half hour: \(perTimeStepper.value)"
        creditsRequired.text = "Credits required: \(requiredStepper.value)"
        creditsPenalized.text = "Penalty for missing exp: \(penaltyStepper.value)"
    }
    
    @IBAction func update(){
        let navigator = parent as! PieraNavigationController
        navigator.currentAdministration!.updateCredits(perTime: perTimeStepper.value, required: requiredStepper.value, penalty: penaltyStepper.value)
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
