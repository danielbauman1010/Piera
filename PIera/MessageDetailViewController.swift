//
//  MessageDetailViewController.swift
//  PIera
//
//  Created by daniel bauman on 6/13/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    var message: Message?
    
    override func viewWillAppear(_ animated: Bool) {
        authorLabel.text = message?.author ?? ""
        messageTextView.text = message?.message ?? ""        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigator = self.navigationController as! PieraNavigationController
        if segue.identifier == "replyToMessage" {
            let personDetailViewController = segue.destination as! PersonDetailViewController
            personDetailViewController.person = Person(name: self.message?.author ?? "", password: "", email: "", university: "", id: self.message?.authorId ?? 0)
        }
    }
    
}
