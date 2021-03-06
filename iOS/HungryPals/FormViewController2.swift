//
//  FormViewController2.swift
//  HungryPals
//
//  Created by Joyce Huang on 3/7/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import UIKit

class FormViewController2: UIViewController {
    @IBOutlet weak var restaurantField: UITextField!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var fromTime: UITextField!
    @IBOutlet weak var toTime: UITextField!
    @IBOutlet weak var error: UILabel!
    
    var button = dropDownBtn()
    var startTime = Date()
    var endTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        error.isHidden = true
        cuisine.isHidden = true
//        cuisine.inputView?.addSubview(button)
        restaurantField.layer.borderColor = UIColor.lightGray.cgColor
        notesField.layer.borderColor = UIColor.lightGray.cgColor
        fromTime.layer.borderColor = UIColor.lightGray.cgColor
        toTime.layer.borderColor = UIColor.lightGray.cgColor
        
        restaurantField.layer.borderWidth = 1.0
        notesField.layer.borderWidth = 1.0
        toTime.layer.borderWidth = 1.0
        fromTime.layer.borderWidth = 1.0
        
        //Configure the button
        button = dropDownBtn.init(frame: CGRect(x: 54, y: 217, width: 270, height: 40))
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: UIScreen.main.bounds.width - 110, y: 217, width: 270, height: 40)
        
        //Add Button to the View Controller
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //button Constraints
//        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 305).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 210).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 55).isActive = true
        //Set the drop down menu's options
//        button.dropView.dropDownOptions = ["Chinese", "American", "Italian", "Japanese", "Korean", "Pizza"]
        var prefs:[String] = []
        let userPref:[Bool] = (DataRepository.shared.user?.cuisineMarked)!
        let cuisines:[String] = DataRepository.shared.cuisine
        for (index, item) in userPref.enumerated() {
            if item {
                prefs.append(cuisines[index])
            }
        }
        button.dropView.dropDownOptions = prefs
        
        //time picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(FormViewController2.dismissPicker))
        fromTime.inputAccessoryView = toolBar
        toTime.inputAccessoryView = toolBar
    }
    
    @IBAction func fromTimeHandleChange(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        //datePickerView.timeZone = NSTimeZone(name: "PTD")! as TimeZone
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(FormViewController2.fromPickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc func fromPickerValueChanged(sender:UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale.current
        //timeFormatter.timeZone = TimeZone(abbreviation: "GMT-7:00")
        timeFormatter.timeZone = TimeZone.current
        
        timeFormatter.dateStyle = DateFormatter.Style.full
        timeFormatter.timeStyle = .short
        fromTime.text = timeFormatter.string(from: sender.date)
        startTime = timeFormatter.date(from: fromTime.text!)!
        print(startTime)
        error.isHidden = true
    }
    
    @IBAction func toTimeHandleChange(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        //datePickerView.timeZone = NSTimeZone(name: "PT")! as TimeZone
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(FormViewController2.toPickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func toPickerValueChanged(sender:UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.locale = NSLocale.current
        timeFormatter.timeZone = TimeZone(abbreviation: "PDT")
        timeFormatter.dateStyle = DateFormatter.Style.full
        toTime.text = timeFormatter.string(from: sender.date)
        endTime = timeFormatter.date(from: toTime.text!)!
        error.isHidden = true
    }
    
    @IBAction func postButton(_ sender: UIButton) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        if button.currentTitle == "" {
            error.text = "Please pick the food you want to eat"
            error.isHidden = false
        } else if fromTime.text == "" {
            error.text = "Please enter a start time"
            error.isHidden = false
        } else if toTime.text == ""{
            error.text = "Please enter a end time"
            error.isHidden = false
        } else if startTime > endTime {
            error.isHidden = false
            error.text = "Invalid time range"
        } else {
            error.isHidden = true
            let creator:User = UIApplication.shared.dataRepository.user!
            UIApplication.shared.dataRepository.createPost(creator: creator, startTime: startTime, endTime: endTime, restaurant: restaurantField.text!, cuisine: button.currentTitle!, notes: notesField.text!)
            print("Creating post... startTime: \(startTime), endTime: \(endTime), resturant: \(restaurantField.text!), cuisine: \(button.currentTitle!), notes: \(notesField.text!)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        dropView = dropDownView.init(frame: CGRect.init(x: 54, y: 217, width: 140, height: 40))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        NSLog(dropDownOptions[indexPath.row])
    }
    
}
extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}
extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    

    
}
