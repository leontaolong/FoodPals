//
//  PostViewController.swift
//  HungryPals
//
//  Created by Ranhao Xu on 3/4/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func addPost(_ sender: UIButton) {
        // add a new post
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let post = posts![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! PostTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let post = posts![indexPath.row]
        //NSLog("User selected row at \(post.getRestaurant())")
        //performSegue(withIdentifier: "showQuestion", sender: subject)
    }
}
