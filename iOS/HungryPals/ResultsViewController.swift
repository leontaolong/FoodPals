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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgurl = "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/27073113_546712599021153_8141215265311775044_n.jpg?oh=6c3ab12fe2ba078a7598e26c7264f2a6&oe=5B0B66E1"
        let url = URL(string: imgurl)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        
//        nameLabel.text = "\(dataRepo.getUser().username)"
//        cuisineLabel.text = "\() food"
//        timeLabel.text = "At \() - \()"
//        notesLabel.text = "\()"
        nameLabel.text = "Estelle Liang"
        cuisineLabel.text = "mexican food"
        timeLabel.text = "At 12:30pm - 1:30pm"
        notesLabel.text = "I have gluten allergies"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

