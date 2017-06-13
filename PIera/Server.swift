//
//  Server.swift
//  PIera
//
//  Created by daniel bauman on 3/6/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import Foundation
class Server {
    
    let url: URL
    var id: Int = 0
    let internet_error = "The request timed out."
    init(url: URL) {
        self.url = url
    }
    
    func classId() -> Int {
        self.id += 1
        return id
    }
    
    func createUser(person: Person, ucode: String) -> Person?{
        guard let r = formRequest(method: "POST", address: "signup", requestData: ["username": "\(person.name)", "password": "\(person.password)", "email": "\(person.email)", "ucode": "\(ucode)"] as [String: Any]), r["createStatus"] == "1", let userIdString = r["userId"], let userId = Int(userIdString), let typeOfUser = r["userType"], let university = r["university"], let pertimeString = r["pertime"], let requiredString = r["required"], let penaltyString = r["penalty"], let pertime = Double(pertimeString), let required = Double(requiredString), let penalty = Double(penaltyString) else {
            return nil
        }
        
        switch typeOfUser {
        case "Student":
            let s = Student(name: person.name, password: person.password, email: person.email, university: university, id: userId)
            s.penalty = penalty
            s.required = required
            s.pertime = pertime
            return s
        case "Teacher":
            let t = Teacher(name: person.name, password: person.password, email: person.email, university: university, id: userId)
            t.penalty = penalty
            t.required = required
            t.pertime = pertime
            return t
        case "Admin":
            let a = Admin(name: person.name, password: person.password, email: person.email, university: university, id: userId)
            a.penalty = penalty
            a.required = required
            a.pertime = pertime
            return a
        default:
            return nil
        }
    }
    
    func login(email: String, password: String, ucode: String) -> Person? {
        guard let r = formRequest(method: "POST", address: "signin", requestData: ["email": "\(email)", "password": "\(password)", "ucode": "\(ucode)"]), let status = r["loginStatus"], status == "1", let userIdString = r["userId"], let userId = Int(userIdString), let typeOfUser = r["userType"], let name = r["username"], let university = r["university"], let pertimeString = r["pertime"], let requiredString = r["required"], let penaltyString = r["penalty"], let pertime = Double(pertimeString), let required = Double(requiredString), let penalty = Double(penaltyString) else {
            return nil
        }
        
        switch typeOfUser {
        case "Student":
            let student = Student(name: name, password: password, email: email, university: university, id: userId)
            if let gradeString = r["grade"], let grade = Double(gradeString){
                student.grade = grade
            }
            student.penalty = penalty
            student.required = required
            student.pertime = pertime
            return student
        case "Teacher":
            let teacher = Teacher(name: name, password: password, email: email, university: university, id: userId)
            teacher.penalty = penalty
            teacher.required = required
            teacher.pertime = pertime
            return teacher
        case "Admin":
            let admin = Admin(name: name, password: password, email: email, university: university, id: userId)
            admin.penalty = penalty
            admin.required = required
            admin.pertime = pertime
            return admin
        default:
            return nil
        }                
    }
    
    func createExperiment(exp: Experiment) -> Experiment? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let unformattedtime = exp.time
        let time = dateFormatter.string(from: unformattedtime as Date)
        let timeToComplete = "\(exp.completionTime)"        
        if let r = formRequest(method: "POST", address: "createexperiment", requestData: ["authorID": exp.authorID, "time": time.description, "timeToComplete": timeToComplete, "explocation": exp.location, "descript": exp.descript, "objective": exp.objective, "maxParticipants": exp.maxParticipants, "requirements": exp.requirements.joined(separator: ","), "expname": exp.name, "credit": exp.creditValue] as [String: Any]) , r["createStatus"]=="1", let  experiment = formatExperiment(data: r, counter: "") {
            return experiment
        }
        return nil
    }
    
    func getStudent(studentId: Int)->Student? {
        guard let r = formRequest(method: "GET", address: "student/\(studentId)", requestData: nil), r["getStatus"] == "1", let name = r["username"], let email = r["email"], let university = r["university"] else {
            return nil
        }
        let student = Student(name: name, password: "", email: email, university: university, id: studentId)
        return student
    }
    
    func getTeacherExperiments(author: Teacher) -> [Experiment]?{
        if let r = formRequest(method
            : "GET", address: "teacherexperiments/\(author.personID)", requestData: nil), r["getStatus"]! == "1"{
            var experiments = [Experiment]()
            var counter = 0
            while let exp = formatExperiment(data: r, counter: "\(counter)") {
                experiments.append(exp)
                counter = counter + 1
            }
            
            return experiments
        }
        return nil
    }
    
    func getTeacherHistory(author: Teacher) -> [Experiment]?{
        if let r = formRequest(method
            : "GET", address: "teacherhistory/\(author.personID)", requestData: nil), r["getStatus"]! == "1"{
            var experiments = [Experiment]()
            var counter = 0
            while let exp = formatExperiment(data: r, counter: "\(counter)") {
                experiments.append(exp)
                counter = counter + 1
            }
            
            return experiments
        }
        return nil
    }
    
    func getStudentHistory(studentId: Int)->[Experiment: Double]? {
        guard let r = formRequest(method: "GET", address: "studenthistory/\(studentId)", requestData: nil), r["getStatus"] == "1" else {
            return nil
        }
        var experiments = [Experiment: Double]()
        var counter = 0
        while let exp = formatExperiment(data: r, counter: "\(counter)") {
            experiments[exp] = Double(r["\(counter)grade"]!)!
            counter = counter + 1
        }
        
        return experiments
    }
    
    func updateRequirements(studentId: Int, requirements: [String])->Bool {
        if let r = formRequest(method: "POST", address: "updaterequirements", requestData: ["userId": "\(studentId)", "requirements": "\(requirements.joined(separator: ","))"]), r["updateStatus"] == "1" {
            return true
        }
        return false
    }
    
    func participateInExperiment(studentId: Int, experimentId: Int) -> Bool{
        if let response = formRequest(method: "POST", address: "participate", requestData: ["userId": "\(studentId)", "expid": "\(experimentId)"]), response["participateStatus"] == "1" {
            return true
        }
        return false
    }
    
    func getRequirements(studentId: Int)->[Int: [String]] {
        if let r = formRequest(method: "GET", address: "studentrequirements/\(studentId)", requestData: nil), r["getStatus"] == "1", let requirements = r["requirements"], let allrequirements = r["allrequirements"]{
            var srequirements = [String]()
            if requirements != "" {
                srequirements = requirements.components(separatedBy: ",")
            }
            var sallrequirements = [String]()
            if allrequirements != "" {
                sallrequirements = allrequirements.components(separatedBy: ",")
            }
            return [0: srequirements, 1: sallrequirements]
        }
        return [0: [String](), 1: [String]()]
    }
    
    func searchForExperiment(studentId: Int)->Experiment?{
        if let r = formRequest(method: "GET", address: "searchforexperiments/\(studentId)", requestData: nil), let status = r["searchStatus"], status == "1", let expidString = r["expid"], let expid = Int(expidString), let expdata = formRequest(method: "GET", address: "experiment/\(expid)", requestData: nil)  {
            return formatExperiment(data: expdata, counter: "")
        }
        return nil
    }
    
    func gradeStudents(studentIds: [Int: Bool], experimentId: Int)->Bool {
        let passedids: [String] = studentIds.keys.filter{studentIds[$0]!}.map{"\($0)"}
        let failedids: [String] = studentIds.keys.filter{!(studentIds[$0]!)}.map{"\($0)"}
        if let r = formRequest(method: "POST", address: "gradestudents", requestData: ["passedids": "\(passedids.joined(separator: ","))", "failedids": failedids.joined(separator: ","), "expid": "\(experimentId)"] as [String: Any]!), r["gradeStatus"] == "1" {
            return true
        }
        return false
    }
    
    func getStudentExperiments(studentId: Int) -> [Experiment]?{
        guard let r = formRequest(method: "GET", address: "studentexperiments/\(studentId)", requestData: nil), r["getStatus"] == "1" else {
            return nil
        }
        var experiments = [Experiment]()
        var counter = 0
        while let exp = formatExperiment(data: r, counter: "\(counter)") {
            experiments.append(exp)
            counter = counter + 1
        }
        return experiments
    }
    
    func getUniversityCodes(university: String) -> [String: String]? {
        guard let r = formRequest(method: "GET", address: "generateucodes/\(university.replacingOccurrences(of: " ", with: "_"))", requestData: nil), r["generateStatus"] == "1", let studentCode = r["studentucode"], let teacherCode = r["teacherucode"], let adminCode = r["adminucode"] else {
            return nil
        }
        return ["student": studentCode, "teacher": teacherCode, "admin": adminCode]
    }
    
    func updateCredits(userId: Int, pertime: Double, required: Double, penalty: Double) -> Bool{
        guard let r = formRequest(method: "POST", address: "updatecredits", requestData: ["userId": "\(userId)", "pertime": "\(pertime)", "required": "\(required)", "penalty": "\(penalty)"] as [String: Any]), r["updateStatus"] == "1" else {
            return false
        }
        return true
    }
    
    func getParticipants(expid: Int) -> [Student]{
        guard let r = formRequest(method: "GET", address: "participants/\(expid)", requestData: nil), r["getStatus"] == "1" else {
            return [Student]()
        }
        var students = [Student]()
        var counter = 0
        while let studentIdString = r["\(counter)userId"], let studentId = Int(studentIdString), let username = r["\(counter)username"], let email = r["\(counter)email"], let university = r["\(counter)university"] {
            students.append(Student(name: username, password: "", email: email, university: university, id: studentId))
            counter = counter + 1
        }
        return students
    }
    
    func sendMessage(authorId: Int, recieverId: Int, message: String)->Bool {
        guard let r = formRequest(method: "POST", address: "sendmessage", requestData: ["authorId": "\(authorId)", "recieverId": "\(recieverId)", "message": message] as [String: Any]), let status = r["sendStatus"], status == "1" else {
            return false
        }
        return true
    }
    
    func getMessages(userId: Int) -> [String: String] {
        var counter = 0
        guard let r = formRequest(method: "GET", address: "messages/\(userId)", requestData: nil), let status = r["getStatus"], status == "1", let _ = r["\(counter)author"] else {
            return [String: String]()
        }
        var messages = [String: String]()
        while r["\(counter)author"] != nil {
            messages[r["\(counter)author"]!] = r["\(counter)message"]!
            counter = counter + 1
        }
        return messages
    }
    
    func formatExperiment(data: [String: String], counter: String)-> Experiment? {
        guard let expname = data["\(counter)expname"], let explocation = data["\(counter)explocation"], let descript = data["\(counter)descript"], let objective = data["\(counter)objective"], let author = data["\(counter)author"], let authorIdString = data["\(counter)authorId"], let email = data["\(counter)email"], let authorId = Int(authorIdString), let requirementsString = data["\(counter)requirements"], let maxParticipantsString = data["\(counter)maxParticipants"], let maxParticipants = Int(maxParticipantsString), let expidString = data["\(counter)expid"], let expid = Int(expidString), let participantsString = data["\(counter)participants"], let stringTime = data["\(counter)time"], let stringTimeToComplete = data["\(counter)timeToComplete"], let timeToComplete = Double(stringTimeToComplete) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let datetime = dateFormatter.date(from: stringTime) ?? Date.init()
        let nsdatetime = datetime as NSDate
        let requirements = requirementsString.components(separatedBy: ",")
        let experiment = Experiment(name: expname, time: nsdatetime, location: explocation, descript: descript, objective: objective, author: author, authorID: authorId, email: email,completionTime: timeToComplete,  requirements: requirements, maxParticipants: maxParticipants, experimentID: expid)
        if participantsString.characters.count > 0 {
            let participants = participantsString.components(separatedBy: ",")
            for participant in participants {
                if let partId = Int(participant) {
                    experiment.studentIDs.append(partId)
                }
            }

        }
        return experiment
    }
    
    func formRequest(method: String, address: String, requestData: [String: Any]?) -> [String: String]?{
        let request = NSMutableURLRequest(url: URL(string: "\(self.url.absoluteString)/\(address)")!)
        var jsonResponse: [String: String]?
        request.httpMethod = method
        if let d = requestData {
            request.httpBody = try? JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        var printout: String?
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                printout = error?.localizedDescription ?? "error"
                print(printout!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: String]
                
                if let parseJSON = json {
                    print("\n\nparseJSON:\n\(parseJSON)\n\n\n")
                    jsonResponse = parseJSON
                }
                
            } catch let error as NSError {
                print(error)
                printout = error.localizedDescription
            }
        }
        if let error = printout {
            return ["error": error]
        }
        task.resume()
        var maxTime = 0
        while jsonResponse == nil && maxTime <= 20 {
            sleep(1)
            maxTime += 1
        }
        return jsonResponse
    }
    
}
