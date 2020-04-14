//
//  NewsViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/03/22.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON
import SafariServices

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //データモデルを格納する配列
    var dataList:[NewsModel] = []
    
    @IBOutlet weak var newsTableView: UITableView!

//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        //カスタムセル
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        newsTableView.register(nib, forCellReuseIdentifier: "NewsCell")
        
        //画面表示時に行う通信処理を追加
        reloadListDatas()

//        // Alamofire
//        AF.request("https://newsapi.org/v2/top-headlines?country=jp&apiKey=59288c383f6b40b1969c83c8fae0f0be").response { response in
//            //debugPrint(response)
//
//            if let jsonObject = response.value{
//
//                //SwiftyJSON
//                let json = JSON(jsonObject)
//                // Getting a string from a JSON Dictionary
//                let articles = json["articles"]
//                // If json is .Dictionary
//                for (key,subJson):(String, JSON) in articles {
//                   // Do something you want
//                    print(subJson["source"]["name"])
//                    print(subJson["author"])
//                    print(subJson["title"])
//                    print(subJson["description"])
//                    print(subJson["url"])
//                    print(subJson["urlToImage"])
//                    print(subJson["publishedAt"])
//                    print(subJson["content"])
//                }
//            }
//        }
        
        
    }
//MARK: - reloadListDatas
    func reloadListDatas(){
        //セッション用のコンフィグを設定・今回はデフォルトの設定
        let config = URLSessionConfiguration.default
        //NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        //接続するURLを指定
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=jp&apiKey=59288c383f6b40b1969c83c8fae0f0be")
        //通信処理タスクを設定
        let task = session.dataTask(with: url!){
            (data,response,error)in
            
            //エラーが発生した場合にのみ処理
            if error != nil {
                //エラーが発生したことをアラート表示
                let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller,animated: true, completion: nil)
                //表示後は処理終了
                return
            }
            //エラーがなければ、JSON形式にデータを変換して格納
            guard let jsonData: Data = data else{
                //エラーが発生したことをアラートで表示
                let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller,animated: true, completion: nil)
                //表示後は処理終了
                return
            }
            
            //self.dataList = try! JSONDecoder().decode([NewsModel].self, from: jsonData)
            let jsonTest = try! JSONDecoder().decode(Test.self, from: jsonData) as Test
            print(jsonTest)
            
            if let articles = jsonTest.articles {
                for newsModel in articles {
                    self.dataList.append(newsModel)
                }
            }
                        //メインスレッドに処理を戻す
            DispatchQueue.main.async {
                //最新のデータに更新する
                self.newsTableView.reloadData()
            }
        }
        //タスクを実施
        task.resume()
    }
//MARK: - テーブルビュー
    //セルがタップされた時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択を解除
        tableView.deselectRow(at: indexPath,animated: true)
        //データを取り出す
        let data = dataList[indexPath.row]
        
//        //記事のURLを取得する
//        if let url = URL(string: data.link){
//
//            //SFSafariViewControllerのインスタンスを生成
//            let controller: SFSafariViewController = SFSafariViewController(url: url)
//
//            //次の画面へ遷移して、表示する
//            self.present(controller,animated: true,completion: nil)
//        }
    }
    //セルのセクション数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        //セクションは１つ
        return 1
    }
    //セルの数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //取得したセルの数だけセルを表示
        return dataList.count
    }
    //セルを構築する際に呼ばれる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //作成した「NewsCell」のインスタンスを生成
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)as! NewsTableViewCell
        
        //取得したデータを取り出す
        let data = dataList[indexPath.row]
        
        
        //日付
        cell.dateLabel.text = data.publishedAt
        //タイトル
        cell.titleLabel.text = data.title
        //本文
        if let desc = data.description {
          cell.descriptionLabel.text = desc
        }
        //著者
        cell.authorLabel.text = data.author
        //画像
        if let url = data.urlToImage {
        //UIImageのExtensionを利用。
        cell.urlToImageView.image =  UIImage.init(url: url)
        }
        //セルのインスタンスを返す
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }


}
