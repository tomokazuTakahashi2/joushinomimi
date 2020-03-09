import UIKit
import Firebase
//import FirebaseUI
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

//        //FirebaseUI
//            let storageRef = Storage.storage().reference()
//            // Reference to an image file in Firebase Storage
//            let reference = storageRef.child("users/\(Auth.auth().currentUser!.uid)/profile-picture.jpg")
//            // UIImageView in your ViewController
//            let imageView: UIImageView = self.profileImageView
//            // Placeholder image
//            let placeholderImage = UIImage(named: "placeholder.jpg")
//            // Load the image using SDWebImage
//            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        // 受け取った画像をImageViewに設定する
        imageView.image = image
    }
    
    //編集完了ボタン
    @IBAction func editingCompletedButton(_ sender: Any) {
        //textViewに反映
        commentView.text = commentTextField.text
        
    }
    //画像を選択するボタン
    @IBAction func imageSelectButton(_ sender: Any) {
        
        let storyboard: UIStoryboard = self.storyboard!

        let nextView = storyboard.instantiateViewController(withIdentifier: "ImageSelect") as! ImageSelectViewController

        self.present(nextView, animated: true, completion: nil)
        
    }
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // ImageViewから画像を取得する
        let imageData = imageView.image!.jpegData(compressionQuality: 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)

        // postDataに必要な情報を取得しておく
        let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        

        // 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath)
        let postDic = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!,"postComment": commentView.text!] as [String : Any]
        postRef.childByAutoId().setValue(postDic)

        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")

        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }

    
    
    
}
