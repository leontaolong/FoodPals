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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        posts = UIApplication.shared.postRepository.getPosts()
        
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
        cell.textLabel?.text = post.getRestaurant()
        //cell.detailTextLabel?.text = post.desc
        //cell.imageView?.image = UIImage(named: post.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts![indexPath.row]
        NSLog("User selected row at \(post.getRestaurant())")
        //performSegue(withIdentifier: "showQuestion", sender: subject)
    }
}
