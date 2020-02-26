//
//  PointsViewController.swift
//  PunchTKITClient
//
//  Created by Vishal Polepalli on 2/10/20.
//  Copyright © 2020 Vishal Polepalli. All rights reserved.
//

import UIKit
import Firebase

class PointsViewController: UIViewController {

    var phoneNumber: String?
    var storeName: String?
    var pointsNeeded: Int?
    var prevVC: ScannerViewController!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if prevVC != nil
        {
            prevVC.dismiss(animated: true, completion: nil)
        }
        storeName = UserDefaults.standard.string(forKey: "StoreName")
        pointsNeeded = UserDefaults.standard.integer(forKey: "PointsNeeded")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func awardPoint(_ sender: Any)
    {
        print("here")
        db.collection("users").document(phoneNumber!).collection("points").document(storeName!).getDocument() { (document, error) in
            if let document = document, document.exists
            {
                var points = document.data()!["Points"] as? Int ?? 0
                points = points + 1
                self.db.collection("users").document(self.phoneNumber ?? "").collection("points").document(self.storeName!).setData(["Points" : points], merge: true)
            }
            else
            {
                print("Document does not exist")
                self.db.collection("users").document(self.phoneNumber ?? "").setData(["PhoneNumber" : self.phoneNumber ?? ""], merge: true)
                self.db.collection("users").document(self.phoneNumber ?? "").collection("points").document(self.storeName!).setData(["StoreName" : self.storeName ?? "", "Points": 1])
            }
            
            let alertController = UIAlertController(title: "Done!", message: "1 Point added" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(okAction)
            self.present(alertController,animated: true)
        }
    }
    
    @IBAction func redeemPoints(_ sender: Any)
    {
        db.collection("users").document(phoneNumber ?? "").collection("points").whereField("StoreName", isEqualTo: storeName ?? "" ).getDocuments(){ (querySnapshot, error) in
            if (querySnapshot?.documents.count)! > 0, let document = querySnapshot?.documents[0], document.exists
            {
                var points = document.data()["Points"] as? Int ?? 0
    
                if points >= self.pointsNeeded!
                {
                    points = points - self.pointsNeeded!
                    print(points,self.pointsNeeded!)
                    self.db.collection("users").document(self.phoneNumber ?? "").collection("points").document(self.storeName!).setData(["Points" : points], merge: true)
                    let alertController = UIAlertController(title: "Done!", message: "Points have been redeemed." , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController,animated: true)
                }
                else
                {
                    let alertController = UIAlertController(title: "Canceled!", message: "Not enough points to redeem reward." , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController,animated: true)
                }
            }
            else
            {
                let alertController = UIAlertController(title: "Canceled!", message: "Not enough points to redeem reward." , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController,animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
