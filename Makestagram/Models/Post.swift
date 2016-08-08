

import Foundation
import Parse
import Bond

// 1
class Post : PFObject, PFSubclassing {
    
    //making the variable observable--creating wrapper around value wish to store to allow binding
    var image: Observable<UIImage?> = Observable(nil)
    
    var photoUploadTask: UIBackgroundTaskIdentifier?


    // 2
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    func uploadPost() {
        
        if let image = image.value {//if image has value
            
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return} //return as jpeg
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return} //store in parse
            
            user = PFUser.currentUser()//initialize
            self.imageFile = imageFile//initialize
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    func downloadImage() {
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            // 2
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    // 3
                    self.image.value = image
                }
            }
        }
    }
}