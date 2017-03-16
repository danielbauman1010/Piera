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
    
    func createUser(username: String, email: String, password: String, classes: [String], bio: String, type: userType) -> [String: String]? {
        var userdata = ["username": username, "Password":password, "email":email, "bio": bio] as [String: Any]
        var counter = 0
        for c in classes {
            userdata["class\(counter)"] = c
            counter = counter + 1
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: userdata, options: .prettyPrinted)
        let url = NSURL(string: "http://localhost:3000/createuser")!
        let request = NSMutableURLRequest(url: url as URL)
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
    
    /*func getMain() {
     let urlString = URL(string: "http://192.168.1.245:3000/")
     if let url = urlString {
     let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
     if error != nil {
     print(error)
     } else {
     if let usableData = data {
     print(usableData)
     }
     }
     }
     task.resume()
     }
     }*/
}
