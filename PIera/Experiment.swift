import UIKit

class Experiment: NSObject {
    var name : String
    var time: NSDate
    var location: String
    var descript: String
    var objective: String
    var author: String
    var authorID: Int
    var completionTime: Double
    var maxParticipants: Int
    var requirements : [String]
    var graded: Bool = false
    var experimentID: Int
    var studentIDs: [Int]
    var grade: Double?
    var gradable: Bool = false
    var email: String
    var creditValue: Double{
        get{
            return Double((Int(completionTime-1.0) / 30)) + 1.0
        }
    }
    
    
    init(name: String, time: NSDate?, location: String?, descript: String?, objective: String?, author: String, authorID: Int, email: String, completionTime: Double, requirements: [String], maxParticipants: Int, experimentID: Int){
        self.name = name
        self.time = time ?? NSDate.init(timeIntervalSinceNow: 0.0)
        self.location = location ?? "not specified"
        self.descript = descript ?? "not specified"
        self.objective = objective ?? "not specified"
        self.author = author
        self.authorID = authorID
        self.email = email
        self.completionTime = completionTime
        self.requirements = requirements
        self.maxParticipants = maxParticipants
        self.experimentID = experimentID
        self.studentIDs = [Int]()
        super.init()
    }
}

