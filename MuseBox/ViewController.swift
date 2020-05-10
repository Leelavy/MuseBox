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
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBAction func allSetButton(_ sender: Any) {
        self.titleLabel.text = "MUSEBOX IS SET!"
        self.logoImageView.image = UIImage(named: "MuseboxTempLogo")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

