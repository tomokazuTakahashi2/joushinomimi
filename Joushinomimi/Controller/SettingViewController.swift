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
import SVProgressHUD
import CLImageEditor

class SettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLImageEditorDelegate {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL:URL?
    
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
        // キーボードを閉じる
        self.view.endEditing(true)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }
    @IBAction func imageChoiceButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
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

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }

    // CLImageEditorで加工が終わったときに呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //FirebaseのDatabaseのURL
        let ref = Database.database().reference(fromURL: "https://joushinomimi.firebaseio.com/")
        //FirebaseのStorageのURL
        let storage = Storage.storage().reference(forURL: "gs://joushinomimi.appspot.com")
        
//        //ユーザーのプロフィールを更新する
//        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
//        let data = imageView.image!.jpegData(compressionQuality: 0.9)!
        
        //let imageString = data.base64EncodedString(options: .lineLength64Characters)
        var imageData:Data = Data()
        //自分だけのIDを発行
        let key = ref.childByAutoId()
        
        //"ProfileImages"の中に"〇〇.jpeg"という形で格納される
        let imageRef = storage.child("ProfileImages").child("\(key).jpeg")
        
        //imageView.imageがnilでなかったら、
        if self.imageView.image != nil{
            //imageView.imageを1/100に圧縮してimageDataというData型に入れる
            imageData = (self.imageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        //アップロード
        //imageDataをimageRefに置きに行く→metaDataかerrorに入ってくる
        let uploadTask = imageRef.putData(imageData,metadata: nil){(metaData,error)in
            //errorがnilじゃなかったら（エラーだったら）、
            if error != nil{
                print(error as Any)
                //ここで止める
                return
            }
            //そうでなかったら（エラーじゃなかったら）、
            imageRef.downloadURL { (url, error) in
                //urlがnilでなかったら（urlかerrorに何か入ってきたら）、
                if url != nil{
                    //urlをimageURLに入れ、
                    self.imageURL = url
                    //imageURLをURL型から String型へ変換（.absoluteString）し、"profileImageString"というキー値で保存する
                    UserDefaults.standard.set(self.imageURL?.absoluteString, forKey: "profileImageString")
                }
          
            }
        }
        uploadTask.resume()

//        photoRef.putData(data, metadata: nil) { (metadata, error) in
//            //もしエラーだったらエラーをプリント
//            if let error = error {
//                print(error)
//                return
//            }
//
//            photoRef.downloadURL { (url, error) in
//                //もしerrorだったら、プリントする
//                if let error = error {
//                    print(error)
//                }
//                //もしurlがnilだったらこれ以上進まない
//                guard let downloadURL = url else {
//                    return
//                }
//                //urlがnilじゃなかったら、以下を実行
//                changeRequest.photoURL = downloadURL
//                changeRequest.commitChanges { (error) in
//                    if let error = error {
//                        print(error)
//                    }
//
//                }
//
//
//            }
//        }
        //imageView.imageに画像を反映する
        self.imageView.image = image!
        //モーダルを閉じる
        editor.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func FinishedEditing(_ sender: Any) {
//
//    }

}
