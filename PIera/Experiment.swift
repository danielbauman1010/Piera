import UIKit

class Experiment: NSObject {
    var name : String
    var time: NSDate?
    var location: String?
    var descript: String?
    var objective: String?
    var author: String
    var authorID: Int
    var completionTime: Double
    var maxParticipants: Int
    var requirements : [String]
    var graded: Bool = false
    
    var studentIDs = [Int]()
    
    var creditValue: Double{
        get{
            return Double((Int(completionTime-1.0) / 30)) + 1.0
        }
    }
    
    
    init(name: String, time: NSDate?, location: String?, descript: String?, objective: String?, author: String, authorID: Int, completionTime: Double, requirements: [String], maxParticipants: Int){
        self.name = name
        self.time = time
        self.location = location
        self.descript = descript
        self.objective = objective
        self.author = author
        self.authorID = authorID
        self.completionTime = completionTime
        self.requirements = requirements
        self.maxParticipants = maxParticipants
        super.init()
    }
}

