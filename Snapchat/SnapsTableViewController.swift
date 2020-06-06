//
//  SnapsTableViewController.swift
//  Snapchat
//
//  Created by Peter Milligan on 2020/05/17.
//  Copyright © 2020 John Milligan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsTableViewController: UITableViewController {
    
    var snaps : [FIRDataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("users").child(uid).child("snaps").observe(.childAdded) { (snapshot) in
                
                
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                FIRDatabase.database().reference().child("users").child(uid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    
                    var index = 0
                    for snap in self.snaps {
                        if snapshot.key == snap.key{
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
                
                /*
                 if let snapDictionary = snapshot.value as? NSDictionary {
                 if let from = snapDictionary["from"] as? String {
                 if let imageName = snapDictionary["imageName"] as? String {
                 if let imageURL = snapDictionary["imageURL"] as? String {
                 if let message = snapDictionary["message"] as? String {
                 
                 }
                 }
                 }
                 }
                 }
                 */
                
            }
        }
        
        
        
    }
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return snaps.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath)
        
        let snap = snaps[indexPath.row]
        
        if let snapDictionary = snap.value as? NSDictionary {
            if let from = snapDictionary["from"] as? String {
                cell.textLabel?.text = from
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "snapsToView", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewSnapVC = segue.destination as? ViewSnapsViewController {
            if let snapshot = sender as? FIRDataSnapshot {
                viewSnapVC.snapshot = snapshot
            }
            
        }
    }
    
}
