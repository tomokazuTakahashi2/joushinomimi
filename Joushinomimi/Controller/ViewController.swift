//
//  ViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/14.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
import Firebase
import ESTabBarController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTab()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }

    func setupTab() {

        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home-50", "search-50", "plus-50","bell-50","setting-50"])

        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        tabBarController.selectionIndicatorHeight = 3

        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChild(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ])
        tabBarController.didMove(toParent: self)

        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "Search")
        let notificationViewController = storyboard?.instantiateViewController(withIdentifier: "Notification")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")

        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(searchViewController, at: 1)
        tabBarController.setView(notificationViewController, at: 3)
        tabBarController.setView(settingViewController, at: 4)

        // 真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 2)
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post")
            self.present(postViewController!, animated: true, completion: nil)
            }, at: 2)
    }
}

