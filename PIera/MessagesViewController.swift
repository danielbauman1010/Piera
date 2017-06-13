//
//  messagesViewController.swift
//  PIera
//
//  Created by daniel bauman on 6/13/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController{
    
    var messages: [String: String]?
    var messagesArray: [String]?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = messages {
            return m.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let messageDis = messagesArray?[indexPath.row] ?? ""
        cell.textLabel?.text = messageDis
        return cell
    }
}
