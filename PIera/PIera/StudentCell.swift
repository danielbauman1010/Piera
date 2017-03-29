import UIKit

class StudentCell: UITableViewCell{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradingSwitch: UISwitch!
    
    func updateLabels(){
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        nameLabel.font = bodyFont
    }
}
