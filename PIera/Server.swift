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
    
    func createStudent(student: Student, ucode: String) -> Student? {
        let studentJson = ["username": student.name, "password": student.password, "email": student.email, "bio": student.bio, "interests": student.interests, "classesEnrolled": student.classes, "ucode": ucode] as [String: Any]
        let response = formRequest(method: "POST", address: "createstudent", requestData: studentJson, params: nil)
        if let r = response, r["createStatus"]! == "1" {
            return Student(name: r["username"]!, password: r["password"]!, email: r["email"]!, interests: r["interests"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func createTeacher(teacher: Teacher, ucode: String) -> Teacher? {
        let teacherJson = ["username": teacher.name, "password": teacher.password, "email": teacher.email, "bio": teacher.bio, "classesEnrolled": teacher.classes, "ucode": ucode] as [String: Any]
        let response = formRequest(method: "POST", address: "createteacher", requestData: teacherJson, params: nil)
        if let r = response, r["createStatus"]! == "1" {
            return Teacher(name: r["username"]!, password: r["password"]!, email: r["email"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func loginStudent(email: String, password: String) -> Student? {
        let studentJson = ["email": email, "password":password] as [String: Any]
        let response = formRequest(method: "POST", address: "loginstudent", requestData: studentJson, params: nil)
        if let r = response, r["loginStatus"] == "1" {
            return Student(name: r["username"]!, password: r["password"]!, email: r["email"]!, interests: r["interests"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func loginTeacher(email: String, password: String) -> Teacher? {
        let teacherJson = ["email": email, "password":password] as [String: Any]
        let response = formRequest(method: "POST", address: "loginteacher", requestData: teacherJson, params: nil)
        if let r = response, r["loginStatus"] == "1" {
            return Teacher(name: r["username"]!, password: r["password"]!, email: r["email"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func createExperiment(exp: Experiment) -> Experiment? {
        let time = exp.time ?? NSDate.init()
        let description = exp.descript ?? "not specified"
        let explocation = exp.location ?? "not specified"
        let objective = exp.objective ?? "not specified"
        let expJson = ["authorID": exp.authorID, "time": time.description, "explocation": explocation, "descript": description, "objective": objective, "maxParticipants": exp.maxParticipants, "requirements": exp.requirements.joined(separator: " "), "expname": exp.name] as [String: Any]
        let response = formRequest(method: "POST", address: "createexperiment", requestData: expJson, params: nil)
        if let r = response, r["createStatus"]=="1" {
            return Experiment(name: exp.name, time: exp.time, location: explocation, descript: description, objective: objective, author: r["author"]!, authorID: exp.authorID, requirements: exp.requirements, maxParticipants: exp.maxParticipants, experimentID: Int(r["expid"]!)!)
        }
        return nil
    }
    
    func getTeacherExperiments(author: Teacher) -> [Experiment]?{
        if let r = formRequest(method
            : "GET", address: "teacherexperiments/\(author.personID)", requestData: nil, params: nil), r["getStatus"]! == "1" {
            var counter = 0
            var experiments = [Experiment]()
            while let expname = r["expname\(counter)"] {
                experiments.append(Experiment(name: expname, time: NSDate.init(timeIntervalSinceNow: 1), location: r["explocation\(counter)"]!, descript: r["descript\(counter)"]!, objective: r["objective\(counter)"]!, author: author.name, authorID: author.personID, requirements: r["requirements\(counter)"]!.components(separatedBy: " "), maxParticipants: Int(r["maxParticipants\(counter)"]!)!, experimentID: Int(r["expid"]!)!))
                counter = counter + 1
            }
            return experiments
        }
        return nil
    }
    
    func participateInExperiment(studentId: Int, experimentId: Int) -> Bool{
        if let response = formRequest(method: "POST", address: "participate", requestData: ["userId": "\(studentId)", "expid": "\(experimentId)"], params: nil), response["participateStatus"] == "1" {
            return true
        }
        return false
    }
    
    func formRequest(method: String, address: String, requestData: [String: Any]?, params: [String:String]?) -> [String: String]?{
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
