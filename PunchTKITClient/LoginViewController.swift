//
//  ViewController.swift
//  PunchTKITClient
//
//  Created by Vishal Polepalli on 2/10/20.
//  Copyright © 2020 Vishal Polepalli. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var storeNameTextEdit: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        storeNameTextEdit.returnKeyType = .done
        storeNameTextEdit.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonPressed(_ sender: Any)
    {
        db.collection("stores").whereField("StoreName", isEqualTo: storeNameTextEdit.text ?? "").limit(to: 1).getDocuments()
        { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
                let alertController = UIAlertController(title: "Failed!", message: "No Store With that name" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController,animated: true)
            }
            else
            {
               
                for document in querySnapshot!.documents
                {
                    print("\(document.documentID) => \(document.data())")
                    UserDefaults.standard.set(document.data()["NumToRecieve"] as? Int ?? 0, forKey: "PointsNeeded" )
                    UserDefaults.standard.set(self.storeNameTextEdit.text ?? "", forKey: "StoreName")
                    self.performSegue(withIdentifier: "loginToScanner", sender: self)
                }
                
            }
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

