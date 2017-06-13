//
//  StudentDetailViewController.swift
//  PIera
//
//  Created by daniel bauman on 6/13/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var universityLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextView!
    
    var person: Person?
    
    override func viewWillAppear(_ animated: Bool) {
        messageTextField.text = ""
        if let p = person {
            personNameLabel.text = p.name
            emailLabel.text = p.email
            universityLabel.text = p.university
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let destination = person {
            let navigator = self.navigationController as! PieraNavigationController
            if navigator.server.sendMessage(authorId: navigator.currentPerson!.personID, recieverId: destination.personID, message: messageTextField.text) {
                print("success")
                messageTextField.text = ""
            } else {
                print("fail")
            }
        }
    }
}
