//
//  SearchResultViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/02/17.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
import Firebase

class SearchResultViewController: UIViewController,UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
        
    
    var postArray: [PostData] = []
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    //MARK: - UISearchControllerから受信
    func updateSearchResults(for searchController: UISearchController) {
        //UISearchControllerの検索窓に入力した文字列を取得
        if let text = searchController.searchBar.text{
            print(text)
//            //データ取得関数を呼び出す
//            self.reloadListDatas(text)
        }
    }
    //MARK: - テーブルビュー
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
