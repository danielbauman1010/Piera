import UIKit

class PieraNavigationController: UINavigationController{
    var currentPerson: Person? = nil
    var currentAdministration: Administration? = nil
    var server = Server(url: URL(string: "https://www.piera.tk")!)
    var debugMode: Bool = false
    var ucode = ""
    var ucodeType: personType = personType.None
    var currentExperiments = [Experiment]()
    var administrations: [Administration] = [Administration(studentCode: "a", teacherCode: "t", adminCode: "s", perTime: 1.0, required: 5.0, penalty: 0.0), Administration(studentCode: "1234", teacherCode: "4321", adminCode: "2143", perTime: 1.0, required: 5.0, penalty: 0.0)]
    var administrators : [Person] = []
    /*func filterTime(comparisonType: ComparisonResult)->[Experiment]{
     //orderedAscending - Past, orderedSame - Present, orderedDescending - Future
     return experiments.filter{($0.time?.compare(Date())) == comparisonType}
     }
     
     var currentExperiments: [Experiment]{
     return filterTime(comparisonType: .orderedDescending)
     }
     
     var pastExperiments: [Experiment]{
     return filterTime(comparisonType: .orderedAscending)
     }
     */
}

enum personType{
    case Student, Teacher, Admin, None
}
