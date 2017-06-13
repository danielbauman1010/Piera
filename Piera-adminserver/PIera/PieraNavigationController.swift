import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var server = Server(url: URL(string: "https://www.piera.tk")!)
    var debugMode: Bool = false
    var ucode = ""
    var currentExperiments = [Experiment]()    
}
