//
//  AccountPreferenceViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/9/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class AccountPreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dataRepo = DataRepository.shared
    //let appdata = AppData.shared
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBAction func btnOK(_ sender: Any) {
        performSegue(withIdentifier: "prefToAccount", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("count")
        return dataRepo.cuisine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath) as! PreferenceTableViewCell
        cell.cuisine.text = dataRepo.cuisine[indexPath.row]
        if (dataRepo.user?.cuisineMarked[indexPath.row])! {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        dataRepo.user?.updatePref(indexPath.row)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        backImg.image = UIImage(named: "account-preference")
        labelName.text = dataRepo.user?.username
        labelEmail.text = dataRepo.user?.email
        
        let url = URL(string: (dataRepo.user?.profilePic)!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        img.image = UIImage(data: data!)
        //img.image = UIImage(named: "log-in")
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
        btnOK.layer.cornerRadius = 5
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
