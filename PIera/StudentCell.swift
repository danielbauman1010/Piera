import UIKit

class StudentCell: UITableViewCell{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradingSwitch: UISwitch!
    
    var selectedForMessaging = false
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        self.selectedForMessaging = true
    }
    func updateLabels(){
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        nameLabel.font = bodyFont
    }
}
