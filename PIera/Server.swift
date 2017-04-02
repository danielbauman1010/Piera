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
        let response = formRequest(method: "POST", address: "createstudent", data: studentJson)
        if let r = response, r["createStatus"]! == "1" {
            return Student(name: r["username"]!, password: r["password"]!, email: r["email"]!, interests: r["interests"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func createTeacher(teacher: Teacher, ucode: String) -> Teacher? {
        let teacherJson = ["username": teacher.name, "password": teacher.password, "email": teacher.email, "bio": teacher.bio, "classesEnrolled": teacher.classes, "ucode": ucode] as [String: Any]
        let response = formRequest(method: "POST", address: "createteacher", data: teacherJson)
        if let r = response, r["createStatus"]! == "1" {
            return Teacher(name: r["username"]!, password: r["password"]!, email: r["email"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }

    func loginStudent(email: String, password: String) -> Student? {
        let studentJson = ["email": email, "password":password] as [String: Any]
        let response = formRequest(method: "POST", address: "loginstudent", data: studentJson)
        if let r = response, r["loginStatus"] == "1" {
            return Student(name: r["username"]!, password: r["password"]!, email: r["email"]!, interests: r["interests"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func loginTeacher(email: String, password: String) -> Teacher? {
        let teacherJson = ["email": email, "password":password] as [String: Any]
        let response = formRequest(method: "POST", address: "loginteacher", data: teacherJson)
        if let r = response, r["loginStatus"] == "1" {
            return Teacher(name: r["username"]!, password: r["password"]!, email: r["email"]!, classes: r["classesEnrolled"]!, bio: r["bio"]!, id: Int(r["userId"]!)!)
        }
        return nil
    }
    
    func formRequest(method: String, address: String, data: [String: Any]) -> [String: String]?{
        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let request = NSMutableURLRequest(url: URL(string: "\(self.url.absoluteString)/\(address)")!)
        var jsonResponse: [String: String]?
        request.httpMethod = method
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
