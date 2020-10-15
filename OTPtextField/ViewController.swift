//
//  ViewController.swift
//  OTPtextField
//
//  Created by POORAN SUTHAR on 13/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate {
    var textfieldEndEditing = true
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet var otptextfield: [UITextField]!
    var keyboardHeight : CGFloat = 0
    var otpDictionary : [UITextField : Int] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textfieldEndEditing = true
        connectButton.layer.cornerRadius = 20.5
        for index in 0 ..< otptextfield.count{
            otpDictionary[otptextfield[index]] = index
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height 
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.buttonAdjust()
        }
    }
    
    func buttonAdjust(){
        buttonTopConstraint.constant =  keyboardHeight + 10
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if  otptextfield[4] ==  textField && textfieldEndEditing == true{
            textfieldEndEditing = false
            //buttonTopConstraint.constant = 100
            return true
        }else if otptextfield[0] == textField && textfieldEndEditing == false{
            //buttonTopConstraint.constant = 100
            textfieldEndEditing = true
            return true
        }
        
        return true
    }
    @IBAction func connectButtonAction(_ sender: Any) {
        
    }
    
    enum Direction {
        case  right
        case  left
    }
    
    func setNextResponder(_ index : Int? , direction : Direction ){
        guard let index = index else {return}
        if direction == .left {
            index == 0 ?
                (_ = otptextfield.first?.resignFirstResponder()) : (_ = otptextfield[(index - 1)].becomeFirstResponder())
        }else{
            index == otptextfield.count - 1 ?
                (_ = otptextfield.last?.resignFirstResponder()) : (_ = otptextfield[(index + 1)].becomeFirstResponder())
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0{
            textField.text = string
            setNextResponder(otpDictionary[textField], direction: .right)
            return true
        }else if range.length == 1{
            textField.text = ""
            setNextResponder(otpDictionary[textField], direction: .left)
            return false
        }
        return false
    }
    
}

