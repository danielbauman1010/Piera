import Foundation

class Person{
    var name: String
    var password: String
    var email: String
    var bio: String
    var personID: Int
    
    init(name: String, password: String, email: String, bio: String, id: Int){
        self.name = name
        self.password = password
        self.email = email
        self.bio = bio
        self.personID = id
    }
}
