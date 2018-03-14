//
//  RequestViewController.swift
//  HungryPals
//
//  Created by Leon T Long on 3/13/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {
    
    var post:Post? = nil
    var postIndex:Int = 0
    let dataRepo = UIApplication.shared.dataRepository
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: (post?.creator.profilePic)!)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        nameLabel.text = "\(post?.creator.username ?? "")"
        cuisineLabel.text = "\(post?.cuisine ?? "") food"
        timeLabel.text = "At \(post?.startTime.toString() ?? "") - \(post?.endTime.toString() ?? "")"
        notesLabel.text = "\(post?.notes ?? "")"
    }
    
    @IBAction func btnEatTogether(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        dataRepo.requestPost(index: postIndex)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


