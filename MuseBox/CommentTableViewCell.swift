//
//  CommentTableViewCell.swift
//  MuseBox
//
//  Created by admin on 17/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

 
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
