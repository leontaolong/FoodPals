//
//  PreferenceViewController.swift
//  HungryPals
//
//  Created by Christy Lu on 3/8/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    let appdata = AppData.shared
    let dataRepo = DataRepository.shared
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("count")
        //return appdata.cuisine.count
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
    
    @IBAction func btnOK(_ sender: Any) {
        print("go to main page ")
    }
    
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        img.image = UIImage(named: "preference-top")
        img.contentMode =  UIViewContentMode.scaleAspectFill
        view.sendSubview(toBack: img)
        btnStart.layer.cornerRadius = 5
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
