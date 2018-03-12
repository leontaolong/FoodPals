//
//  ResultsViewController.swift
//  HungryPals
//
//  Created by Joyce Huang on 3/7/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    let dataRepo = DataRepository.shared
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    //TODO: change to actual notification
    var notification = Post.init(postId: "12381379", creator: User.init(username: "JOyce", email: "String", location: "String", userId: "String", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/27073113_546712599021153_8141215265311775044_n.jpg?oh=6c3ab12fe2ba078a7598e26c7264f2a6&oe=5B0B66E1", deviceToken: "String"), createdAt: Date(timeIntervalSinceReferenceDate: -123456789.0), status: "CONFIRMED", startTime: Date(timeIntervalSinceReferenceDate: -123456789.0), endTime: Date(timeIntervalSinceReferenceDate: -123456389.0), restaurant: "none", cuisine: "Chinese", notes: "I don't like spice")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: notification.creator.profilePic)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
        nameLabel.text = "\(notification.creator.username)"
        cuisineLabel.text = "\(notification.cuisine) food"
        timeLabel.text = "At \(notification.startTime.toString()) - \(notification.endTime.toString())"
        notesLabel.text = "\(notification.notes)"
    }
    
        @IBAction func eatTogetherBtn(_ sender: UIButton) {
        print("eat together")
            
        //TODO: Open Messenger when status is CONFIRMED
        if notification.status == "CONFIRMED" {
            let alertVC = UIAlertController(title: "Woohoo! Not lonely anymore!",
                                            message: "Want to open Messenger to chat with \(notification.creator.username)?",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.cancel) { _ in
                alertVC.dismiss(animated: true)
            })
            alertVC.addAction(UIAlertAction(title: "Open", style: .default) { _ in
                let url  = NSURL(string: "https://messenger.com")
                let application = UIApplication.shared

                if application.canOpenURL(url! as URL) {
                    application.open(url! as URL)
                }
            })
            self.present(alertVC, animated: true)
        }else{
            //TODO: Redirect to homepage when status is REQUESTED
        }
    }
    
    @IBAction func noThanksBtn(_ sender: UIButton) {
        print("back to home screen")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

