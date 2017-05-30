import Foundation

class Student: Person{
    var credits: Double
    var requirements: [String]
    var experiments: [Experiment]
    
    override init(name: String, password: String, email: String, university: String, id: Int){
        self.credits = 0.0
        self.requirements = [String]()
        self.experiments = [Experiment]()
        super.init(name: name, password: password, email: email, university: university, id: id)
    }
}
