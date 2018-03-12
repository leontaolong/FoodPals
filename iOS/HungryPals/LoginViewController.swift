//
//  LoginViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/1/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    //@IBOutlet weak var facebookInfo: UILabel!
    //let appdata = AppData.shared
    var fbLogin = false
    let dataRepo = DataRepository.shared
    let this = self
    @IBOutlet weak var fbIcon: UIImageView!
    @IBAction func btnLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends, .userLocation], viewController: self) { result in
            switch result {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("user cancelled the login")
            case .success(_, _, _):
                self.fbLogin = true
                self.getUserInfo { userInfo, error in
                    if let error = error { print(error.localizedDescription)}
                    if let userInfo = userInfo, let id = userInfo["id"], let name = userInfo["name"], let email = userInfo["email"], let pictureUrl = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String, let location = userInfo["location"] as? NSDictionary {

                        self.dataRepo.createUser(username:name as! String, email:email as! String, location:(location["name"] as? String)!, userId:id as! String, profilePic:pictureUrl, deviceToken:UserDefaults.standard.string(forKey: "deviceToken")!)
                    }
                    self.goToPref()
                }
                // segue

                
            }
        }
    }
    
    func goToPref() {
        self.performSegue(withIdentifier: "loginToPreference", sender: self)
    }
    
    
    func getUserInfo(completion: @escaping (_:[String: Any]?, _:Error?) -> Void) {
        let request = GraphRequest(graphPath: "me",parameters: ["fields": "id, name, email, picture, friends, location"])
        request.start { response, result in
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                completion(graphResponse.dictionaryValue, nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "log-in")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        fbIcon.image = UIImage(named: "fb")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fbLogin {
            goToPref()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
