//
//  imageExtension.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

extension UIImageView {

    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.clipsToBounds = true
    }
}
