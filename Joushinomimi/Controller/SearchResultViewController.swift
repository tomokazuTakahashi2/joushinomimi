//
//  SearchResultViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/17.
//  Copyright © 2020 takahashi. All rights reserved.
//

//import UIKit
//
//class SearchResultViewController: UIViewController,UISearchResultsUpdating {
//    
//    var dataList:[SampleModel] = []
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    func updateSearchResults(for searchController: UISearchController) {
//        //UISearchControllerの検索窓に入力した文字列を取得
//        if let text = searchController.searchBar.text{
//            //データ取得関数を呼び出す
//            self.reloadListDatas(text)
//        }
//    }
//    func reloadListDatas(_text:String){
//        //文字列の時は処理を行わない
//        if text.isEmpty{
//            return
//        }
//        //セッションのコンフィグを設定・今回はデフォルトの設定
//        let config = URLSessionConfiguration.default
//        //NSURLSessionのインスタンスを生成
//        let session = URLSession(configuration: config)
//        //検索する文字列が日本語の場合もあるため、エンコードする
//        let urlString = "https://"
//    
//    }
//    
//
//
//}
