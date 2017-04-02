import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var server = Server(url: URL(string: "https://www.piera.tk")!)
    var experiments = [Experiment]()
    var debugMode: Bool = false
    var ucode = "" 
    func filterTime(comparisonType: ComparisonResult)->[Experiment]{
        //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
        return experiments.filter{($0.time?.compare(Date())) == comparisonType}
    }
    
    var currentExperiments: [Experiment]{
        return filterTime(comparisonType: .orderedDescending)
    }
    
    var pastExperiments: [Experiment]{
        return filterTime(comparisonType: .orderedAscending)
    }
}
