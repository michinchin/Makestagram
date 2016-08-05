//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Abigail Chin on 8/3/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
    
    var photoTakingHelper: PhotoTakingHelper?
    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets TimelineViewController to be the delegate of the tab bar--the first screen
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // fetches the query of follow relationships
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // adding pictures from those whom u are following
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // retrieve posts the current user has posted
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // will return contraints from above two queries
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        // resolve pointer and download all info about user
        query.includeKey("user")
        // formats timeline to show most recent pictures
        query.orderByDescending("createdAt")
        
        // kick off network request
        query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            // receive all posts that meet requirements and try to store in array, if empty, store empty array
            self.posts = result as? [Post] ?? []
            // refresh table view once receiving all new posts
            self.tableView.reloadData()
        }
    }

}


// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let post = Post()
            post.image = image
            post.uploadPost()
        }
    }

    /*If the PhotoTab is pressed, will call take photo function*/
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // cast cell to custon type, PostTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        // using postImageView property to decide which image to display
        cell.postImageView.image = posts[indexPath.row].image
        
        return cell
    }
}




