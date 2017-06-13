import Foundation

class Teacher: Person{
    var classes: String
    
    init(name: String, password: String, email: String, classes: String, id: Int){
        self.classes = classes
        super.init(name: name, password: password, email: email, id: id)
    }
}
