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
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func createUser(username: String, email: String, password: String, classes: String, bio: String, type: userType) -> [String: String]? {
        var userdata = ["Username": username, "Password":password, "email":email, "bio": bio] as [String: Any]
        var counter = 0
        var classesArray = classes.components(separatedBy: " ")
        for c in classesArray {
            userdata["class\(counter)"] = c
            counter = counter + 1
        }
        switch type {
        case .Student: userdata["User"] = "Student"
        case .Teacher: userdata["User"] = "Teacher"
        case .Administrator: userdata["User"] = "Administrator"
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: userdata, options: .prettyPrinted)
        let request = NSMutableURLRequest(url: self.url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var res: [String: String]?
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print(error?.localizedDescription ?? "error")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? [String: String]
                
                if let parseJSON = json {
                    print(parseJSON)
                    res = [String: String]()
                    for (key,value) in parseJSON {
                        res![key] = value
                    }
                }
                print("\(response)")
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
        return res
    }
    
}
