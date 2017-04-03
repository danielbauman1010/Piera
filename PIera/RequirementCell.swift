import UIKit

class RequirementCell: UITableViewCell{
    @IBOutlet var requirementLabel: UILabel!
    @IBOutlet var requirementSwitch: UISwitch!
    
    func updateLabels(){
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        requirementLabel.font = bodyFont
    }
}
