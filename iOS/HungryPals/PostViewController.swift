//
//  PostViewController.swift
//  HungryPals
//
//  Created by Ranhao Xu on 3/4/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let post = posts![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = post.getCreator().getUsername()
        cell.detailTextLabel?.text = "Wants to eat \(post.getRestaurant())\n At \(post.getStartTime().toString()) - \(post.getEndTime().toString()), Today"
        
        let imageUrl = URL(string: post.getCreator().getProfilePic())!
        
        let imageData = try! Data(contentsOf: imageUrl)
        
        //let image = UIImage(data: imageData)
        
        cell.imageView?.image = UIImage(data: imageData)
        //cell.imageView?.image = UIImage(named: post.getCreator().getProfilePic())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts![indexPath.row]
        NSLog("User selected row at \(post.getRestaurant())")
        //performSegue(withIdentifier: "showQuestion", sender: subject)
    }
}
