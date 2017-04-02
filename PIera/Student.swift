import Foundation

class Student: Person{
    var interests: String
    var classes: String
    var requirements = [String]()
    
    init(name: String, password: String, email: String, interests: String, classes: String, bio: String, id: Int){
        self.interests = interests
        self.classes = classes
        super.init(name: name, password: password, email: email, bio: bio, id: id)
    }
}
