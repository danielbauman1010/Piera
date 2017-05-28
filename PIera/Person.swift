import Foundation

class Person{
    var name: String
    var password: String
    var email: String
    var personID: Int
    var university: String
    var pertime: Double = 0.5
    var required: Double = 5.0
    var penalty: Double = 0.0
    init(name: String, password: String, email: String, university: String, id: Int){
        self.name = name
        self.password = password
        self.email = email
        self.personID = id
        self.university = university
    }
}

class Student: Person{
    var grade: Double = 0
    var experiments: [Experiment]
    var gradedExperiments: [Experiment: Double]
    override init(name: String, password: String, email: String, university: String, id: Int){                
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
    override init(name: String, password: String, email: String, university: String, id: Int) {
        super.init(name: name, password: password, email: email, university: university, id: id)
    }
}
