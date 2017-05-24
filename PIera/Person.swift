import Foundation

class Person{
    var name: String
    var password: String
    var email: String
    var personID: Int
    var university: String
    init(name: String, password: String, email: String, university: String, id: Int){
        self.name = name
        self.password = password
        self.email = email
        self.personID = id
        self.university = university
    }
}

class Student: Person{
    var grade: Double {
        var g = 0.0
        for e in gradedExperiments {
            g += e.value
        }
        return g
    }
    var requirements: [String]
    var experiments: [Experiment]
    var gradedExperiments: [Experiment: Double]
    override init(name: String, password: String, email: String, university: String, id: Int){        
        self.requirements = [String]()
        self.experiments = [Experiment]()
        self.gradedExperiments = [Experiment: Double]()
        super.init(name: name, password: password, email: email, university: university, id: id)
    }
}

class Teacher: Person{
    var experiments: [Experiment]
    override init(name: String, password: String, email: String, university: String, id: Int){
        self.experiments = [Experiment]()
        super.init(name: name, password: password, email: email, university: university, id: id)
    }
}

class Admin: Person {
    var pertime: Double
    var required: Double
    var penalty: Double
    override init(name: String, password: String, email: String, university: String, id: Int) {
        self.pertime = 0.5
        self.required = 5.0
        self.penalty = 0.0
        super.init(name: name, password: password, email: email, university: university, id: id)
    }
}
