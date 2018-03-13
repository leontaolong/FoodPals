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
    @IBOutlet weak var buttonBar: UIView!
    
    let dataRepo = UIApplication.shared.dataRepository
    var pendingPosts: [Post] = []
    var confirmedPosts: [Post] = []
    var matchablePosts: [Post] = []
    var user: User? = nil
    var state: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pendingPosts = dataRepo.pendingPosts
        confirmedPosts = dataRepo.confirmedPosts
        user = dataRepo.getUser()
        matchablePosts = dataRepo.matchablePosts
        
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
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
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
            UIView.animate(withDuration: 0.3) {
                self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            }
        case 1:
            state = 1
            updateTable()
            UIView.animate(withDuration: 0.3) {
                self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            }
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
        var getPost:Post? = nil
        if state == 0 {
            getPost = pendingPosts[index]
        }
        else {
            getPost = confirmedPosts[index]
        }
        let post = getPost!
        
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
                let postId = pendingPosts[indexPath.row].postId
                pendingPosts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                dataRepo.httpDeletePost(postId)
            }
        }
    }
}
