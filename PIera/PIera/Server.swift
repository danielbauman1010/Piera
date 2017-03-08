//
//  Server.swift
//  PIera
//
//  Created by daniel bauman on 3/6/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import Foundation
class Server {

    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    enum userType {
        case Student, Teacher, Administrator
    }
    
    func createUser(username: String, email: String, password: String, classes: [String], bio: String, type: userType) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            } else {
                if let usableData = data {
                    print(usableData)
                }
            }
        }
        task.resume()
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
