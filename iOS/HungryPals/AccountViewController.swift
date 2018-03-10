//
//  AccountViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/6/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    //@IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var img: UIImageView!
    let appdata = AppData.shared
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnEdit(_ sender: Any) {
        appdata.fromProfile = true
    }
    @IBAction func btnLogout(_ sender: Any) {
        LoginManager().logOut()
        performSegue(withIdentifier: "profileToLogin", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdata.accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! PreferenceTableViewCell
        print(appdata.location)
        if appdata.accountList[indexPath.row] == "Live in " {
            print("IM HERE \(appdata.location)")
            cell.accountList.text =
            "Live in \(appdata.location)"
        } else {
            cell.accountList.text = appdata.accountList[indexPath.row]
        }

        cell.accountIcon.image = UIImage(named: appdata.accountListIcon[indexPath.row])
        return cell
    }
    
    
    
    //@IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.picker.dataSource = self
        //self.picker.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        print("appdata")
        print(appdata.cuisine)
        print(appdata.id)
        print(appdata.name)
        print(appdata.location)
        print(appdata.profilePicUrl)
        print(appdata.email)
        labelName.text = appdata.name
        labelEmail.text = appdata.email
        
        let url = URL(string: appdata.profilePicUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        img.image = UIImage(data: data!)
        //img.image = UIImage(named: "log-in")
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
        // Do any additional setup after loading the view.
        btnLogout.layer.cornerRadius = 5
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
