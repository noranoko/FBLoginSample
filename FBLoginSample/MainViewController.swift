//
//  MainViewController.swift
//  FBLoginSample
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentUserName: UILabel!
    @IBOutlet weak var currentUserEmail: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var userProfile : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnUserData()
      }

    @IBAction func logout(sender: AnyObject) {
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // エラー処理
                println("Error: \(error)")
            }
            else
            {
                // プロフィール情報をディクショナリに入れる
                self.userProfile = result as! NSDictionary
                println(self.userProfile)

                // プロフィール画像の取得（よくあるように角を丸くする）
                let profileImageURL : String = self.userProfile.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
                var profileImage = UIImage(data: NSData(contentsOfURL: NSURL(string: profileImageURL)!)!)
                self.userImage.clipsToBounds = true
                self.userImage.layer.cornerRadius = 60
                self.userImage.image = self.trimPicture(profileImage!)

                //名前とemail
                
                self.currentUserName.text = self.userProfile.objectForKey("name") as? String
                self.currentUserEmail.text = self.userProfile.objectForKey("email") as? String

                }
        })
    
    }
    
    func trimPicture(rawPic:UIImage) -> UIImage {
        var rawImageW = rawPic.size.width
        var rawImageH = rawPic.size.height
            
        var posX = (rawImageW - 200) / 2
        var posY = (rawImageH - 200) / 2
        var trimArea : CGRect = CGRectMake(posX, posY, 200, 200)
            
        var rawImageRef:CGImageRef = rawPic.CGImage
        var trimmedImageRef = CGImageCreateWithImageInRect(rawImageRef, trimArea)
        var trimmedImage : UIImage = UIImage(CGImage : trimmedImageRef)!
        return trimmedImage
    }
}
