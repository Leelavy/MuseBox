//
//  ViewController.swift
//  MuseBox
//
//  Created by admin on 10/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func allSetButton(_ sender: Any) {
        self.titleLabel.text = "MUSEBOX IS SET!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

