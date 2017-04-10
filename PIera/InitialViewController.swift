import UIKit

class InitialViewController: UIViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigator = parent as! PieraNavigationController
        navigator.navigationBar.isHidden = true
    }
}
