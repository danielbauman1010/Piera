import Foundation

class Student: Person{
    var classes: String
    var credits: Double = 0.0
    var requirements = [String]()
    
    init(name: String, password: String, email: String, classes: String, id: Int){
        self.classes = classes
        super.init(name: name, password: password, email: email, id: id)
    }
}
