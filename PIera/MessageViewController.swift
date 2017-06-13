//
//  MessageViewController.swift
//  PIera
//
//  Created by daniel bauman on 6/11/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    var messageDestination: Person?
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    override func viewWillAppear(_ animated: Bool) {
        let name = messageDestination?.name ?? ""
        authorLabel.text = "Message to: \(name)"
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let navigator = self.navigationController as! PieraNavigationController!
        print(navigator!.server.sendMessage(authorId: navigator!.currentPerson!.personID, recieverId: messageDestination!.personID, message: messageTextView.text))
        if let _ = navigator?.currentPerson as? Teacher {
            performSegue(withIdentifier: "backToTeacherMain", sender: nil)
        } else {
            performSegue(withIdentifier: "backToStudentMain", sender: nil)
        }
    }
    
}
