import UIKit

class AdminMainController: UIViewController{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var creditsPerTime: UILabel!
    @IBOutlet var creditsRequired: UILabel!
    @IBOutlet var creditsPenalized: UILabel!
    @IBOutlet var perTimeStepper : UIStepper!
    @IBOutlet var requiredStepper : UIStepper!
    @IBOutlet var penaltyStepper : UIStepper!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = !navigator.debugMode
        let admin = navigator.currentPerson!
        
        nameLabel.text = "User: \(admin.name)"
        //Update for administration from server
        creditsPerTime.text = "Credits per half hour: \(navigator.currentAdministration!.perTime)"
        creditsRequired.text = "Credits required: \(navigator.currentAdministration!.required)"
        creditsPenalized.text = "Penalty for missing exp: \(navigator.currentAdministration!.penalty)"
    }
    
    @IBAction func update(){
        let navigator = parent as! PieraNavigationController
        navigator.currentAdministration?.updateCredits(perTime: perTimeStepper.value, required: requiredStepper.value, penalty: penaltyStepper.value)
    }
}
