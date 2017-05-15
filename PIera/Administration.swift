import Foundation

struct Administration{
    let studentCode: String
    let teacherCode: String
    let adminCode: String
    
    var perTime: Double
    var required: Double
    var penalty: Double
    
    mutating func updateCredits(perTime: Double, required: Double, penalty: Double){
        self.perTime = perTime
        self.required = required
        self.penalty = penalty
    }
}
