//
//  ProgressExtension.swift
//  MuseBox
//
//  Created by admin on 15/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showIndicator(title:String, description:String) {
        
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.contentColor = UIColor.init(red: 19, green: 59, blue: 81, alpha: 1)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
    }
    
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
