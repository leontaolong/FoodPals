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
    
    let dataRepo = DataRepository.shared
    var posts: [Post]? = nil
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts = UIApplication.shared.dataRepository.getMatchablePosts()
        user = UIApplication.shared.dataRepository.getUser()
        
        // Do any additional setup after loading the view.
        postsTable.dataSource = self
        postsTable.delegate = self
        //postsTable.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count;
    }
    
    private func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let post = posts![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = post.creator.username
        cell.detailTextLabel?.text = "Wants to eat \(post.cuisine)\nAt \(post.startTime.toString()) - \(post.endTime.toString()), Today"
        
        let imageUrl = URL(string: post.creator.profilePic)!
        let imageData = try! Data(contentsOf: imageUrl)
        cell.imageView?.image = maskRoundedImage(image: UIImage(data: imageData)!, radius: CGFloat(160))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts![indexPath.row]
        NSLog("User selected row at \(post.restaurant)")
        //performSegue(withIdentifier: "showQuestion", sender: subject)
    }
}
