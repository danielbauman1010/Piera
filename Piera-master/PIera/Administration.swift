import Foundation

class Administration{
    let name: String
    let studentCode: String
    let teacherCode: String
    let adminCode: String
    
    var perTime: Double = 0.5
    var required: Double = 5.0
    var penalty: Double = 0.0
    
    init(name: String, studentCode: String, teacherCode: String, adminCode: String){
        self.name = name
        self.studentCode = studentCode
        self.teacherCode = teacherCode
        self.adminCode = adminCode
    }
    
    func updateCredits(perTime: Double, required: Double, penalty: Double){
        self.perTime = perTime
        self.required = required
        self.penalty = penalty
    }
}
