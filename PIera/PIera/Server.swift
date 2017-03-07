//
//  Server.swift
//  PIera
//
//  Created by daniel bauman on 3/6/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import Foundation
class Server {
    func getMain() {
        /*var request = URLRequest(url: URL(string: "http://192.168.1.245:3000")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            }.resume()
 */
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
    }
}
