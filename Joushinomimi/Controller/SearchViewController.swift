//
//  SearchViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/15.
//  Copyright © 2020 takahashi. All rights reserved.
//

//import UIKit
//
//class SearchViewController: UIViewController{
//
//    var searchController: UISearchController!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //検索結果を表示するSearchResultViewControllerのインスタンスを生成
//        let searchResultViewController = SearchResultViewController()
//        
//        //UISearchControllerのインスタンス生成＆検索結果画面をSearchResultViewControllerに指定
//        searchController = UISearchController(searchResultsController: searchResultViewController)
//        
//        //このクラスを表示の起点とする
//        self.definesPresentationContext = true
//        
//        //ナビゲーションバーに検索窓を表示する
//        self.navigationItem.searchController = searchController
//        
//        //ナビゲーションバーにタイトルを入れる
//        self.title = "検索"
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.largeTitleDisplayMode = .automatic
//        
//        //検索処理をどのクラスで処理するかを指定
//        //SearchResultViewControllerを指定
//        searchController.searchResultsUpdater = searchResultViewController
//        
//        
//        
//    }
//
//}
