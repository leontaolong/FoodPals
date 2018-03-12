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
    
    let dataRepo = DataRepository.shared
    var matchablePosts: [Post] = []
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //matchablePosts = dataRepo.matchablePosts
        matchablePosts = [Post.init(postId: "12381379", creator: User.init(username: "JOyce", email: "String", location: "String", userId: "String", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/27073113_546712599021153_8141215265311775044_n.jpg?oh=6c3ab12fe2ba078a7598e26c7264f2a6&oe=5B0B66E1", deviceToken: "String"), createdAt: Date(timeIntervalSinceReferenceDate: -123456789.0), status: "PENDING", startTime: Date(timeIntervalSinceReferenceDate: -123456789.0), endTime: Date(timeIntervalSinceReferenceDate: -123456389.0), restaurant: "none", cuisine: "Chinese", notes: "I don't like spice")]
        //users = dataRepo.getUser()
        user = User.init(username: "Joyce", email: "123@mail", location: "Seattle", userId: "abc", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/19399486_10212812938654492_7422685381260620425_n.jpg?oh=fff1d310d6981f211aa180b5ef90ca02&oe=5B4173E4", deviceToken: "wc")
        
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
        return matchablePosts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let post = self.matchablePosts[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! PostTableViewCell
        cell.nameLabel?.text = post.creator.username
        cell.cuisineLabel?.text = post.cuisine
        cell.timeLabel?.text = "At \(post.startTime.toString()) - \(post.endTime.toString()), \(post.startTime.compareToToday())"
        
        let imageUrl = URL(string: post.creator.profilePic)!
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
