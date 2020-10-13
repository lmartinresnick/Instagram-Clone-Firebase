//
//  UploadViewController.swift
//  InstagramCloneFirebase37
//
//  Created by Luke Martin-Resnick on 9/25/20.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadTextfield: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        uploadImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        view.addGestureRecognizer(imageTapRecognizer)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func uploadTapped(_ sender: Any) {
        
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("Media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "ERROR")
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageURL = url?.absoluteString
                            
                            
                            // DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageURL" : imageURL!, "postedBy" : Auth.auth().currentUser!.email!, "postCaption" : self.uploadTextfield.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.uploadImageView.image = UIImage(named: "select")
                                    self.uploadTextfield.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
            }
        }
        
    }
    
}
