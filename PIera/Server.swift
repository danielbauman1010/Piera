//
//  Server.swift
//  PIera
//
//  Created by daniel bauman on 3/6/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import Foundation
class Server {
    
    enum userType {
        case Student, Teacher, Administrator
    }
    
    var jsonResponse: [String: String]?
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func createUser(username: String, email: String, password: String, classes: String, bio: String, type: userType) -> [String: String]? {
        var userdata = ["username": username, "password":password, "email":email, "bio": bio] as [String: Any]
        var counter = 0
        let classesArray = classes.components(separatedBy: " ")
        for c in classesArray {
            userdata["class\(counter)"] = c
            counter = counter + 1
        }
        switch type {
        case .Student: userdata["typeOfUser"] = "Student"
        case .Teacher: userdata["typeOfUser"] = "Teacher"
        case .Administrator: userdata["typeOfUser"] = "Administrator"
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: userdata, options: .prettyPrinted)
        let request = NSMutableURLRequest(url: URL(string: "\(self.url.absoluteString)/createuser")!)
        request.httpMethod = "POST"
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
                    self.jsonResponse = parseJSON
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
        var maxTime = 0
        while self.jsonResponse == nil && maxTime <= 15 {
            sleep(2)
            maxTime += 1
        }
        return self.jsonResponse
    }
    
    func login(email: String, password: String) -> [String: String]? {
        self.jsonResponse = nil
        let userdata = ["email": email, "password":password] as [String: Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: userdata, options: .prettyPrinted)
        let request = NSMutableURLRequest(url: URL(string: "\(self.url.absoluteString)/login")!)
        request.httpMethod = "POST"
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
                    self.jsonResponse = parseJSON
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
        var maxTime = 0
        while self.jsonResponse == nil && maxTime <= 15 {
            sleep(2)
            maxTime += 1
        }
        return self.jsonResponse
    }
    
    
    
}
