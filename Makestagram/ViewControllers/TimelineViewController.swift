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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets TimelineViewController to be the delegate of the tab bar--the first screen
        self.tabBarController?.delegate = self
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
}




