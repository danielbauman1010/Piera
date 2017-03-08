import Foundation

class Person{
    var name: String
    var password: String
    var email: String
    var bio: String
    var personID: Int
    
    static var nextID = 0
    
    static func getNextID()->Int{
        Person.nextID += 1
        return Person.nextID
    }
    
    init(name: String, password: String, email: String, bio: String){
        self.name = name
        self.password = password
        self.email = email
        self.bio = bio
        personID = Person.getNextID()
    }
}
