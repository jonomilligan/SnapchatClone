//
//  ViewSnapsViewController.swift
//  Snapchat
//
//  Created by Peter Milligan on 2020/06/06.
//  Copyright © 2020 John Milligan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapsViewController: UIViewController {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var snapshot : FIRDataSnapshot?
    var imageName = ""
    var snapID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapshot = snapshot {
            if let snapDictionary = snapshot.value as? NSDictionary {
                if let imageName = snapDictionary["imageName"] as? String {
                    if let imageURL = snapDictionary["imageURL"] as? String {
                        if let message = snapDictionary["message"] as? String {
                            messageLabel.text = message
                            
                            if let url = URL(string: imageURL) {
                                imageView.sd_setImage(with: url)
                            }
                            
                            self.imageName = imageName
                            
                            snapID = snapshot.key
                        }
                    }
                }
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            FIRDatabase.database().reference().child("users").child(uid).child("snaps").child(snapID).removeValue()
            FIRStorage.storage().reference().child("images").child(imageName).delete(completion: nil)

        }
    }
    
}
