//
//  SearchViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/15.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController,UISearchBarDelegate{
    
    
    @IBOutlet var searchBar: UISearchBar!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートを設定
        searchBar.delegate = self
        //キャンセルボタンを表示
        searchBar.showsCancelButton = true
        
    }

       
       // SearchBarのデリゲードメソッド
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           // キャンセルされた場合、検索は行わない。
           searchBar.text = ""
           self.view.endEditing(true)
            print("検索をしません")
       }
       //検索ボタンをクリック
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // キーボードを閉じる。
            self.view.endEditing(true)
//            // 検索処理を実行する。
//            searchItems(searchText: searchBar.text! as String)

            dismiss(animated: true, completion: nil)
            
       }



}

