//
//  ViewController.swift
//  PIera
//
//  Created by daniel bauman on 2/14/17.
//  Copyright © 2017 daniel bauman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let server = Server()
        server.getMain()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Comment to test git
}

