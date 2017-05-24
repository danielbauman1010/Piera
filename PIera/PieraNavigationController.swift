import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var server = Server(url: URL(string: "https://www.piera.tk")!)
    var debugMode: Bool = false
    var ucode = ""
    var currentExperiments = [Experiment]()
    var penalty = 0.0
    var perTime = 0.5
    var required = 5.0
}
