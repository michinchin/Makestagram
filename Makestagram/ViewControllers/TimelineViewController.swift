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
        print(posts.count)
        //sets TimelineViewController to be the delegate of the tab bar--the first screen
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestForCurrentUser {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            for post in self.posts {
                do {
                    let data = try post.imageFile?.getData()
                    post.image = UIImage(data: data!, scale:1.0)
                } catch {
                    print("could not get image")
                }
            }
            
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
        let image = posts[indexPath.row].image
        cell.postImageView.image = image
        
        return cell
    }
}




