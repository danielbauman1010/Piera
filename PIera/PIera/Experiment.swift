import UIKit

class Experiment: NSObject {
    var name : String
    var time: NSDate?
    var location: String?
    var descript: String?
    var objective: String?
    var author: String
    
    init(name: String, time: NSDate?, location: String?, descript: String?, objective: String?, author: String){
        self.name = name
        self.time = time
        self.location = location
        self.descript = descript
        self.objective = objective
        self.author = author
        super.init()
    }
    
    convenience init(random: Bool = false){
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(adjectives.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            
            
            self.init(name: randomName, time: NSDate(), location: randomName, descript: randomName, objective: randomName, author: randomName)
        }
        else{
            self.init(name: "Experiment Sample", time: NSDate(), location: "Room 3024", descript: "Have students do something", objective: "Learn something", author: "Bill")
        }
    }
}

