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
    
    init(url: URL) {
        self.url = url
    }
    
    func classId() -> Int {
        self.id += 1
        return id
    }
    
    func createUser(person: Person, ucode: String) -> Person?{
        guard let r = formRequest(method: "POST", address: "signup", requestData: ["username": "\(person.name)", "password": "\(person.password)", "email": "\(person.email)", "ucode": "\(ucode)"] as [String: Any]), r["createStatus"] == "1", let userIdString = r["userId"], let userId = Int(userIdString), let typeOfUser = r["userType"] else {
            return nil
        }
        
        switch typeOfUser {
        case "Student":
            guard let udata = formRequest(method: "GET", address: "student/\(userId)", requestData: nil), let university = udata["university"] else {
                return nil
            }
            return Student(name: person.name, password: person.password, email: person.email, university: university, id: userId)
        case "Teacher":
            guard let udata = formRequest(method: "GET", address: "teacher/\(userId)", requestData: nil), let university = udata["university"] else {
                return nil
            }
            return Teacher(name: person.name, password: person.password, email: person.email, university: university, id: userId)
        case "Admin":
            guard let udata = formRequest(method: "GET", address: "admin/\(userId)", requestData: nil), let university = udata["university"] else {
                return nil
            }
            return Admin(name: person.name, password: person.password, email: person.email, university: university, id: userId)
        default:
            return nil
        }
    }
    
    func login(email: String, password: String, ucode: String) -> Person? {
        guard let r = formRequest(method: "POST", address: "signin", requestData: ["email": "\(email)", "password": "\(password)", "ucode": "\(ucode)"]), let status = r["loginStatus"], status == "1", let userIdString = r["userId"], let userId = Int(userIdString), let typeOfUser = r["userType"] else {
            return nil
        }
        
        switch typeOfUser {
        case "Student":
            guard let udata = formRequest(method: "GET", address: "student/\(userId)", requestData: nil), let name = udata["username"], let university = udata["university"] else {
                return nil
            }
            let student = Student(name: name, password: password, email: email, university: university, id: userId)
            if let history = getStudentHistory(studentId: userId) {
                student.gradedExperiments = history
            }
            return student
        case "Teacher":
            guard let udata = formRequest(method: "GET", address: "teacher/\(userId)", requestData: nil), let name = udata["username"], let university = udata["university"] else {
                return nil
            }
            return Teacher(name: name, password: password, email: email, university: university, id: userId)
        case "Admin":
            guard let udata = formRequest(method: "GET", address: "admin/\(userId)", requestData: nil), let name = udata["username"], let university = udata["university"] else {
                return nil
            }
            return Admin(name: name, password: password, email: email, university: university, id: userId)
        default:
            return nil
        }                
    }
    
    func createExperiment(exp: Experiment) -> Experiment? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let unformattedtime = exp.time ?? NSDate.init(timeIntervalSinceNow: 0.0)
        let time = dateFormatter.string(from: unformattedtime as Date)
        let timeToComplete = "\(exp.completionTime)"
        let description = exp.descript ?? "not specified"
        let explocation = exp.location ?? "not specified"
        let objective = exp.objective ?? "not specified"
        let expJson = ["authorID": exp.authorID, "time": time.description, "timeToComplete": timeToComplete, "explocation": explocation, "descript": description, "objective": objective, "maxParticipants": exp.maxParticipants, "requirements": exp.requirements.joined(separator: ","), "expname": exp.name] as [String: Any]
        let response = formRequest(method: "POST", address: "createexperiment", requestData: expJson)
        if let r = response, r["createStatus"]=="1", let expidString = r["expid"], let expid = Int(expidString) {
            if let expdata = formRequest(method: "GET", address: "experiment/\(expid)", requestData: nil), expdata["getStatus"] == "1" {
                return formatExperiment(data: expdata)
            }
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
            : "GET", address: "teacherexperiments/\(author.personID)", requestData: nil), r["getStatus"]! == "1", let expids = r["expids"], expids.characters.count > 0 {
            var experiments = [Experiment]()
            
            for expid in expids.components(separatedBy: ",") {
                if let experimentdata = formRequest(method: "GET", address: "experiment/\(expid)", requestData: nil), let experiment = formatExperiment(data: experimentdata) {
                    experiments.append(experiment)
                }
            }
            return experiments
        }
        return nil
    }
    
    func getStudentHistory(studentId: Int)->[Int: Double]? {
        guard let r = formRequest(method: "GET", address: "studenthistory/\(studentId)", requestData: nil), r["getStatus"] == "1", let experimentsString = r["experiments"] else {
            return nil
        }
        var experiments = [Int: Double]()
        if experimentsString.characters.count > 0{
            for exp in experimentsString.components(separatedBy: ",") {
                let spexp = exp.components(separatedBy: ":")
                if let expid = Int(spexp[0]), let grade = Double(spexp[1]) {
                    experiments[expid] = grade
                }
            }
        }
        
        return experiments
    }
    
    func getRequirements()->[String] {
        if let r = formRequest(method: "GET", address: "requirements", requestData: nil), let requirements = r["requirements"] {
            return requirements.components(separatedBy: ",")
        }
        return [String]()
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
    
    func getStudentRequirements(studentId: Int)->[String] {
        if let r = formRequest(method: "GET", address: "studentrequirements/\(studentId)", requestData: nil), r["getStatus"] == "1" {
            return r["requirements"]!.components(separatedBy: ",")
        }
        return [String]()
    }
    
    func searchForExperiment(studentId: Int)->Experiment?{
        if let r = formRequest(method: "GET", address: "searchforexperiments/\(studentId)", requestData: nil), let status = r["searchStatus"], status == "1", let expidString = r["expid"], let expid = Int(expidString), let expdata = formRequest(method: "GET", address: "experiment/\(expid)", requestData: nil)  {
            return formatExperiment(data: expdata)
        }
        return nil
    }
    
    func gradeStudent(studentId: Int, experimentId: Int, grade: Double)->Bool {
        if let r = formRequest(method: "POST", address: "gradestudent", requestData: ["userId": "\(studentId)", "expid": "\(experimentId)", "grade": "\(grade)"] as [String: Any]!), r["gradeStatus"] == "1" {
            return true
        }
        return false
    }
    
    func getStudentExperiments(studentId: Int) -> [Experiment]?{
        guard let r = formRequest(method: "GET", address: "studentexperiments/\(studentId)", requestData: nil), r["getStatus"] == "1", let expidstring = r["expids"], expidstring.characters.count > 0 else {
            return nil
        }
        
        let expids = expidstring.components(separatedBy: ",")        
        var experiments = [Experiment]()
        if expids.count > 0 {
            for expid in expids {
                if let exp = formRequest(method: "GET", address: "experiment/\(expid)", requestData: nil), let experiment = formatExperiment(data: exp) {
                    experiments.append(experiment)
                }
            }
        }
        return experiments
    }
    
    func getUniversityCodes(university: String) -> [String: String]? {
        guard let r = formRequest(method: "GET", address: "generateucodes/\(university)", requestData: nil), r["generateStatus"] == "1", let studentCode = r["studentucode"], let teacherCode = r["teacherucode"], let adminCode = r["adminucode"] else {
            return nil
        }
        return ["student": studentCode, "teacher": teacherCode, "admin": adminCode]
    }
    
    func getCredits(university: String) -> [String: Double]? {
        guard let r = formRequest(method: "GET", address: "credits/\(university)", requestData: nil), r["getStatus"] == "1", let pertimeString = r["pertime"], let requiredString = r["required"], let penaltyString = r["penalty"], let pertime = Double(pertimeString), let required = Double(requiredString), let penalty = Double(penaltyString) else {
            return nil
        }
        
        return ["pertime": pertime, "required": required, "penalty": penalty]
    }
    
    func updateCredits(userId: Int, pertime: Double, required: Double, penalty: Double) -> Bool{
        guard let r = formRequest(method: "POST", address: "updatecredits", requestData: ["userId": "\(userId)", "pertime": "\(pertime)", "required": "\(required)", "penalty": "\(penalty)"] as [String: Any]), r["updateStatus"] == "1" else {
            return false
        }
        return true
    }
    
    func formatExperiment(data: [String: String])-> Experiment? {
        guard let expname = data["expname"], let explocation = data["explocation"], let descript = data["descript"], let objective = data["objective"], let author = data["author"], let authorIdString = data["authorId"], let authorId = Int(authorIdString), let requirementsString = data["requirements"], let maxParticipantsString = data["maxParticipants"], let maxParticipants = Int(maxParticipantsString), let expidString = data["expid"], let expid = Int(expidString), let participantsString = data["participants"], let stringTime = data["time"], let stringTimeToComplete = data["timeToComplete"], let timeToComplete = Double(stringTimeToComplete) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let datetime = dateFormatter.date(from: stringTime) ?? Date.init()
        let nsdatetime = datetime as NSDate
        let requirements = requirementsString.components(separatedBy: " ")
        let experiment = Experiment(name: expname, time: nsdatetime, location: explocation, descript: descript, objective: objective, author: author, authorID: authorId, completionTime: timeToComplete,  requirements: requirements, maxParticipants: maxParticipants, experimentID: expid)
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
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print(error?.localizedDescription ?? "error")
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
            }
        }
        task.resume()
        var maxTime = 0
        while jsonResponse == nil && maxTime <= 15 {
            sleep(2)
            maxTime += 1
        }
        return jsonResponse
    }
    
}
