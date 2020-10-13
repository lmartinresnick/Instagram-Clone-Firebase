//
//  FeedViewController.swift
//  InstagramCloneFirebase37
//
//  Created by Luke Martin-Resnick on 9/25/20.
//

import UIKit
import Firebase
import SDWebImage
import OneSignal

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    let fireStoreDatabase = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        
        
        // Player IDs
        
        let status : OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        let playerID = status.subscriptionStatus.userId
        
        if let playerNewID = playerID {
            
            fireStoreDatabase.collection("PlayerID").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { (snapshot, error) in
                if error == nil {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents {
                            if let playerIDFromFirebase = document.get("player id") as? String {
                                let documentId = document.documentID
                                
                                if playerNewID != playerIDFromFirebase {
                                    
                                    
                                    let playerIDDictionary = ["email" : Auth.auth().currentUser!.email, "player id" : playerNewID] as! [String : Any]
                                    
                                    self.fireStoreDatabase.collection("PlayerID").addDocument(data: playerIDDictionary) { (error) in
                                        if error != nil {
                                            print(error?.localizedDescription ?? "Error")
                                        }
                                    }
                                }
                                    
                            }
                            
                            
                        }
                    } else {
                        let playerIDDictionary = ["email" : Auth.auth().currentUser!.email, "player id" : playerNewID] as! [String : Any]
                        
                        self.fireStoreDatabase.collection("PlayerID").addDocument(data: playerIDDictionary) { (error) in
                            if error != nil {
                                print(error?.localizedDescription ?? "Error")
                            }
                        }
                    }
                }
            }
            
            
            
            
        }
        
    
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore() {
        
        
        
        /*let settings = fireStoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fireStoreDatabase.settings = settings */
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postCaption = document.get("postCaption") as? String {
                            self.userCommentArray.append(postCaption)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let image = document.get("imageURL") as? String {
                            self.userImageArray.append(image)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.useremailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
        
    }
    

    

}
