//
//  PreferenceViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/8/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        img.image = UIImage(named: "preference-top")
        img.contentMode =  UIViewContentMode.scaleAspectFill
        view.sendSubview(toBack: img)

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
