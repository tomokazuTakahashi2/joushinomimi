//
//  SettingViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/14.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseUI
import SVProgressHUD
import CLImageEditor


class SettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLImageEditorDelegate {
    
    var imageURL:URL?
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //FirebaseUI
        let storageRef = Storage.storage().reference()
        // Reference to an image file in Firebase Storage
        let reference = storageRef.child("users/\(Auth.auth().currentUser!.uid)/profile-picture.jpg")
        // UIImageView in your ViewController
        let imageView: UIImageView = self.imageView
        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.jpg")
        // Load the image using SDWebImage
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)

        // 表示名とを取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameLabel.text = user.displayName
        }
        
    }
    // 表示名変更ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {

            // 表示名が入力されていない時はHUDを出して何もしない
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }

            // 表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        displayNameLabel.text = displayNameTextField.text
        // キーボードを閉じる
        self.view.endEditing(true)
        //textfieldをからにする
        displayNameTextField.text = ""
    }

    //プロフィール画像変更ボタン
    @IBAction func imageChoiceButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    //カメラロールから写真を取得
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage

            // あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            // CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            picker.pushViewController(editor, animated: true)
        }
    }
    //ピッカーを閉じる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }

    // CLImageEditorで加工が終わったときに呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        
        let storage = Storage.storage().reference()
        //プロフィール画像の変更
        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
        //画像を圧縮
        let data = imageView.image!.jpegData(compressionQuality: 0.9)!
        
        let photoRef = storage.child("users/\(Auth.auth().currentUser!.uid)/profile-picture.jpg")
        
        //storageに画像を送信
        //成功すればmetaDataへ、失敗すればerrorに値が入る
        photoRef.putData(data, metadata: nil) { (metadata, error) in
            //エラーの場合
            if let error = error {
                print(error)
                return
            }
            //成功すればurlへ、失敗すればerrorに値が入る
            photoRef.downloadURL { (url, error) in
                //エラーの場合
                if let error = error {
                    print(error)
                }
                //もしurlがnillだったら進まない(return)、nillじゃなかったら、次に進む
                guard let downloadURL = url else {
                    return
                }
                
//                let timeLineDB = Database.database().reference().child(Const.PostPath)
//                let timeLineInfo = ["profileImage":url?.absoluteString as Any]
//                timeLineDB.updateChildValues(timeLineInfo)
//                
                //nilじゃなかったら、画像を変更する
                changeRequest.photoURL = downloadURL
                changeRequest.commitChanges { (error) in
                    if let error = error {
                        print(error)
                    }
                }
                // 画面を閉じるコマンド
                editor.dismiss(animated: true, completion: nil)
            }
        }
        //イメージビューに反映する
        self.imageView.image = image!
    
    }
    // ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()

        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)

        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
}
