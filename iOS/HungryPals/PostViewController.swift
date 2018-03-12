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
    
    let dataRepo = DataRepository.shared
    var pendingPosts: [Post] = []
    var confirmedPosts: [Post] = []
    var user: User? = nil
    var state: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pendingPosts = dataRepo.pendingPosts
        //confirmedPosts = dataRepo.confirmedPosts
        //user = dataRepo.getUser()
        //matchablePosts = dataRepo.matchablePosts
        pendingPosts = [Post.init(postId: "12381379", creator: User.init(username: "JOyce", email: "String", location: "String", userId: "String", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/27073113_546712599021153_8141215265311775044_n.jpg?oh=6c3ab12fe2ba078a7598e26c7264f2a6&oe=5B0B66E1", deviceToken: "String"), createdAt: Date(timeIntervalSinceReferenceDate: -123456789.0), status: "WAITING", startTime: Date(timeIntervalSinceReferenceDate: -123456789.0), endTime: Date(timeIntervalSinceReferenceDate: -123456389.0), restaurant: "none", cuisine: "Chinese", notes: "I don't like spice")]
        confirmedPosts = [Post.init(postId: "12381379", creator: User.init(username: "YOU", email: "String", location: "String", userId: "String", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/27073113_546712599021153_8141215265311775044_n.jpg?oh=6c3ab12fe2ba078a7598e26c7264f2a6&oe=5B0B66E1", deviceToken: "String"), createdAt: Date(timeIntervalSinceReferenceDate: -123456789.0), status: "MATCHED", startTime: Date(timeIntervalSinceReferenceDate: -123456789.0), endTime: Date(timeIntervalSinceReferenceDate: -123456389.0), restaurant: "none", cuisine: "Chinese", notes: "I don't like spice")]
        user = User.init(username: "Joyce", email: "123@mail", location: "Seattle", userId: "abc", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/19399486_10212812938654492_7422685381260620425_n.jpg?oh=fff1d310d6981f211aa180b5ef90ca02&oe=5B4173E4", deviceToken: "wc")
        
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
        case 0:
            state = 0
            updateTable()
        case 1:
            state = 1
            updateTable()
        default: break;
        }
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.postsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == 0 {
            return pendingPosts.count;
        }
        else if state == 1 {
            return confirmedPosts.count;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        var post = pendingPosts[index]
        if state == 1 {
            post = confirmedPosts[index]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel?.text = post.creator.username
        cell.cuisineLabel?.text = post.cuisine
        cell.timeLabel?.text = "At \(post.startTime.toString()) - \(post.endTime.toString()), \(post.startTime.compareToToday())"
        switch post.status {
        case "MATCHED":
            cell.statusLabel?.text = ""
        case "REQUESTED":
            cell.statusLabel?.text = " Sent "
        case "WAITING":
            cell.statusLabel?.text = " Waiting "
        default:
            break
        }
        cell.statusLabel?.layer.cornerRadius = 3
        cell.statusLabel?.sizeToFit()
        
        let imageUrl = URL(string: post.creator.profilePic)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)!
        cell.profilePic?.image = image
        cell.profilePic?.layer.cornerRadius = (cell.profilePic?.frame.height)! / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if state == 0 {
                pendingPosts.remove(at: indexPath.row)
                dataRepo.httpDeletePost(pendingPosts[indexPath.row].postId)
            }
            else if state == 1 {
                confirmedPosts.remove(at: indexPath.row)
                dataRepo.httpDeletePost(confirmedPosts[indexPath.row].postId)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
