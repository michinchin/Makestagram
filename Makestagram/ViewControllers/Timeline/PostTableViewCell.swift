//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Abigail Chin on 8/5/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse


class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    @IBAction func moreButtonTapped(sender: AnyObject) {
    }
    @IBAction func likeButtonTapped(sender: AnyObject) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var post: Post? {
        didSet {
            // 1
            if let post = post {
                // bind the image of the post to the 'postImage' view
                post.image.bindTo(postImageView.bnd_image)
            }
        }
    }

}
