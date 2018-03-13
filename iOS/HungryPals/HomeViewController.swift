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
    
    let dataRepo = UIApplication.shared.dataRepository
    var matchablePosts: [Post] = []
    var user: User? = nil
    var selectedPost:Post? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchablePosts = dataRepo.matchablePosts
        user = dataRepo.getUser()
        
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

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RequestSegue" ,
            let nextScene = segue.destination as? RequestViewController ,
            let indexPath = self.postsTable.indexPathForSelectedRow {
            let selectedPost = matchablePosts[indexPath.row]
            nextScene.post = selectedPost
            nextScene.postIndex = indexPath.row
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RequestSegue" {
//            if segue.destination is RequestViewController {
//                segue.destination.post = selectedPost
//            }
//        }
//    }
}
