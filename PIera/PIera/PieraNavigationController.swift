import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var experiments = [Experiment]()
    var server = Server(url: URL(string: "https://www.piera.tk")!)
}
