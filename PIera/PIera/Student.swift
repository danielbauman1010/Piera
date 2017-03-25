import Foundation

class Student: Person{
    var interests: String
    var classes: String
    
    init(name: String, password: String, email: String, interests: String, classes: String, bio: String){
        self.interests = interests
        self.classes = classes
        super.init(name: name, password: password, email: email, bio: bio)
    }
}
