import Foundation

class Person{
    var name: String
    var password: String
    var email: String
    var personID: Int
    
    init(name: String, password: String, email: String, id: Int){
        self.name = name
        self.password = password
        self.email = email
        self.personID = id
    }
}
