//
//  AccountViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/6/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController  {
    

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var img: UIImageView!
    let appdata = AppData.shared
    
    @IBAction func btnEdit(_ sender: Any) {
        appdata.fromProfile = true
    }
    //@IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.picker.dataSource = self
        //self.picker.delegate = self
        print("appdata")
        print(appdata.cuisine)
        print(appdata.id)
        print(appdata.name)
        print(appdata.location)
        print(appdata.profilePicUrl)
        print(appdata.email)
        /*labelName.text = appdata.name
        labelEmail.text = appdata.email
        labelLocation.text = appdata.location
        
        let url = URL(string: appdata.profilePicUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        img.image = UIImage(data: data!)*/
        img.image = UIImage(named: "log-in")
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appdata.cuisine.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return appdata.cuisine[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // code here
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
