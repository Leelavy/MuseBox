//
//  EventInfoViewController.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController {
    
    var event: Event?
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameLabel.text = event?.eventName
        descriptionTextView.text = event?.description
        if event?.eventImgUrl != "" {
            eventImg.kf.setImage(with: URL(string: (event?.eventImgUrl)!))
        }
        else {
            eventImg.image = UIImage(named: "imgPlaceholder")
        }
        
        if (event != nil){
            let information = "\(String(describing: event!.date)) @ \(String(describing: event!.location)), \(String(describing: event!.time))"
            informationLabel.text = information
        }
        else {informationLabel.text = "no data"}
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
