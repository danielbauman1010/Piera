import Foundation

class Teacher: Person{
    var classes: [String]
    
    init(name: String, password: String, email: String, classes: [String], bio: String){
        self.classes = classes
        super.init(name: name, password: password, email: email, bio: bio)
    }
}
