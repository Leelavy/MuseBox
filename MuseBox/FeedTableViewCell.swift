//
//  FeedTableViewCell.swift
//  MuseBox
//
//  Created by admin on 11/05/2020.
//  Copyright © 2020 Lee Lavy. All rights reserved.
//

import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func feedTableViewCell(_ feedTableViewCell: FeedTableViewCell, deleteButtonTappedFor postId: String)
}

class FeedTableViewCell: UITableViewCell {

    var postId: String?
    var delegate: FeedTableViewCellDelegate?
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.deleteBtn.addTarget(self, action: #selector(deleteBtn_ToucUpInside(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func deleteBtn_ToucUpInside(_ sender: UIButton) {
        Model.instance.getPostImgUrlByPostId(postId: postId!) { (imgUrl) in
            Model.instance.deletePostImg(imgUrl: imgUrl!) { (success) in
                if success {
                    if let pId = self.postId, let delegate = self.delegate {
                        self.delegate?.feedTableViewCell(self, deleteButtonTappedFor: pId)
                    }
                }
            }
        }
    }

    
}
