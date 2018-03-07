//
//  AccountViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/6/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var img: UIImageView!
    let appdata = AppData.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("appdata")
        print(appdata.id)
        print(appdata.name)
        print(appdata.location)
        print(appdata.profilePicUrl)
        print(appdata.email)
        labelName.text = appdata.name
        labelEmail.text = appdata.email
        labelLocation.text = appdata.location
        
        let url = URL(string: appdata.profilePicUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        img.image = UIImage(data: data!)
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
        // Do any additional setup after loading the view.
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
