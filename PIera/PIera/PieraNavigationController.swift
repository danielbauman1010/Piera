import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var students = [Student]()
    var teachers = [Teacher]()
    var experiments = [Experiment]()
    
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
