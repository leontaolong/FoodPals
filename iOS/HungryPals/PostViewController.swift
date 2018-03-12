//
//  PostViewController.swift
//  HungryPals
//
//  Created by Ranhao Xu on 3/4/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
}

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var postsTable: UITableView!
    
    let postRepo = PostRepository.shared
    var posts: [Post]? = nil
    var users: [User]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts = UIApplication.shared.postRepository.getPosts()
        users = UIApplication.shared.postRepository.getUsers()
        
        // Do any additional setup after loading the view.
        postsTable.dataSource = self
        postsTable.delegate = self
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Lato-Bold", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 179/255, blue: 0/255, alpha: 1.0)
            ], for: .selected)
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Lato-Bold", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: update(state: 0)
        case 1: update(state: 1)
        default: break;
        }
    }
    
    func update(state: Int) {
        if state == 0 {
            // display my waiting post
        }
        else if state == 1 {
            // display my matched post
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let post = posts![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel?.text = post.getCreator().getUsername()
        cell.cuisineLabel?.text = post.getCuisine()
        cell.timeLabel?.text = "At \(post.getStartTime().toString()) - \(post.getEndTime().toString()), \(post.getStartTime().compareToToday())"
        switch post.getMatchingStatus() {
        case "matched":
            cell.statusLabel?.text = " Matched "
        case "no-matches":
            cell.statusLabel?.text = " No Matches "
        case "waitingResponse":
            cell.statusLabel?.text = " Sent "
        default:
            break
        }
        cell.statusLabel?.layer.cornerRadius = 3
        cell.statusLabel?.sizeToFit()
        
        let imageUrl = URL(string: post.getCreator().getProfilePic())!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)!
        cell.profilePic?.image = image
        cell.profilePic?.layer.cornerRadius = (cell.profilePic?.frame.height)! / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            posts!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
