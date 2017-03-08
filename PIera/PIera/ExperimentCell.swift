import UIKit

class ExperimentCell: UITableViewCell{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    func updateLabels(){
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        nameLabel.font = bodyFont
        
        let caption1Font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        timeLabel.font = caption1Font
        locationLabel.font = caption1Font
    }
}
