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
    //let appdata = AppData.shared
    let dataRepo = DataRepository.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnEdit(_ sender: Any) {
        //appdata.fromProfile = true
    }
    @IBAction func btnLogout(_ sender: Any) {
        LoginManager().logOut()
        performSegue(withIdentifier: "profileToLogin", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRepo.accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! PreferenceTableViewCell
        if dataRepo.accountList[indexPath.row] == "Live in " {
            cell.accountList.text = "Live in \(dataRepo.user?.location ?? "")"
        } else {
            cell.accountList.text = dataRepo.accountList[indexPath.row]
        }
        cell.accountIcon.image = UIImage(named: dataRepo.accountListIcon[indexPath.row])
        return cell
    }
    
    
    
    //@IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        labelName.text = dataRepo.user?.username
        labelEmail.text = dataRepo.user?.email
        
        
        let url = URL(string: (dataRepo.user?.profilePic)!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        img.image = UIImage(data: data!)
        img.layer.cornerRadius = img.frame.height / 2
        img.clipsToBounds = true
        // Do any additional setup after loading the view.
        btnLogout.layer.cornerRadius = 5

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
