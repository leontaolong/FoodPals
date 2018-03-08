//
//  FormViewController.swift
//  HungryPals
//
//  Created by Joyce Huang on 3/7/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//
import UIKit

class FormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var cuisineText: UITextField!
    @IBOutlet weak var cuisinePicker: UIPickerView!
    @IBOutlet weak var textbox2: UITextField!

    
    @IBOutlet weak var dropdown2: UIPickerView!
    
    
    var age = ["10-20","20-30","30-40"]
    var Gender = ["Male","Female"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = age.count
        if pickerView == dropdown2 {
            
            countrows = self.Gender.count
        }
        
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cuisinePicker {
            
            let titleRow = age[row]
            
            return titleRow
            
        }
            
        else if pickerView == dropdown2{
            let titleRow = Gender[row]
            
            return titleRow
        }
        
        return ""
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == cuisinePicker {
            self.cuisineText.text = self.age[row]
            self.cuisinePicker.isHidden = true
        }
            
        else if pickerView == dropdown2{
            self.textbox2.text = self.Gender[row]
            self.dropdown2.isHidden = true
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.cuisineText){
            self.cuisinePicker.isHidden = true
            
        }
        else if (textField == self.textbox2){
            self.dropdown2.isHidden = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.cuisinePicker.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

