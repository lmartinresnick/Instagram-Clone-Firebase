//
//  FeedCell.swift
//  InstagramCloneFirebase37
//
//  Created by Luke Martin-Resnick on 9/25/20.
//

import UIKit
import Firebase
import OneSignal

class FeedCell: UITableViewCell {

    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            
            
        }
        
        let userEmail = useremailLabel.text!
        
        fireStoreDatabase.collection("PlayerID").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
            if error == nil {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let playerID = document.get("player id") as? String {
                            OneSignal.postNotification(["contents": ["en": "\(Auth.auth().currentUser!.email!) liked your post"], "include_player_ids": ["\(playerID)"]])
                        }
                    }
                }
            }
        }
        
        // PUSH NOTIFICATION
        
        
        
    }
}
