//
//  ChoiceViewController.swift
//  PunchTKITClient
//
//  Created by Vishal Polepalli on 2/12/20.
//  Copyright © 2020 Vishal Polepalli. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTextFields: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var text: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        continueButton.isHidden = true
        phoneNumberTextFields.delegate = self
        phoneNumberTextFields.keyboardType = .numberPad
        self.addDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text = textField.text?.digitsOnly() ?? ""
        if text.count >= 10
        {
            continueButton.isEnabled = true
            self.performSegue(withIdentifier: "phoneToPoints", sender: self)
        }
        else
        {
            let alertController = UIAlertController(title: "Invalid!", message: "Please enter a valid number to continue. ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PointsViewController
        {
            let vc = segue.destination as? PointsViewController
            vc?.phoneNumber = text
        }
    }
    
    @objc func doneButtonAction()
    {
      self.phoneNumberTextFields.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
      
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
      
      var items = [UIBarButtonItem]()
      items.append(flexSpace)
      items.append(done)
      
      doneToolbar.items = items
      doneToolbar.sizeToFit()
      
      self.phoneNumberTextFields.inputAccessoryView = doneToolbar
      
    }
    


}

extension String
{
    func digitsOnly() -> String
    {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
        .joined()
    }
}
