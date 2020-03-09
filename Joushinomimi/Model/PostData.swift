//
//  PostData.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/15.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
import Firebase
//import Kingfisher

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var profileImageString: String?
    var url: UIImage?
    var profileImage: UIImage?
    var caption: String?
    var postComment: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key

        let valueDictionary = snapshot.value as! [String: Any]

        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)

        self.name = valueDictionary["name"] as? String
        
        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        // Create a reference to the file you want to download
//        let starsRef = storageRef.child("users/\(Auth.auth().currentUser!.uid)/profile-picture.jpg")
//        let timeLineDB = Database.database().reference().child(Const.PostPath)
//
//        // Fetch the download URL
//        starsRef.downloadURL { url, error in
//          if let error = error {
//            // Handle any errors
//            print(error)
//          } else {
//            // Get the download URL for 'images/stars.jpg'
//            //もしurlがnillだったら進まない(return)、nillじゃなかったら、次に進む
//            guard let downloadURL = url else {
//                return
//            }
//            let timeLineInfo = ["profileImage":url?.absoluteString as Any]
//            timeLineDB.updateChildValues(timeLineInfo)
//          }
//        }
        
        let profileImageString = valueDictionary["profileImage"] as? String
        
//        let url = URL(string: profileImageString!)
        print("--------------------")
        print(profileImageString)
        print("--------------------")

        self.caption = valueDictionary["caption"] as? String
        self.postComment = valueDictionary["postComment"] as? String

        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)

        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }

        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
    }
}
