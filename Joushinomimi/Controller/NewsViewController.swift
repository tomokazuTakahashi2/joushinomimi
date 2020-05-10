//
//  NewsViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/03/22.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
import SDWebImage
//import SwiftyJSON
import SafariServices

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //インジケーター（ぐるぐる）
    var activityIndicatorView = UIActivityIndicatorView()

    //データモデルを格納する配列
    var dataList:[NewsModel] = []
    
    let refresh = UIRefreshControl()
    
    @IBOutlet weak var newsTableView: UITableView!

//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //読み込み中
        // インジゲーターの設定
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple
        view.addSubview(activityIndicatorView)
        // アニメーション開始
        activityIndicatorView.startAnimating()

        DispatchQueue.global(qos: .default).async {
            // 非同期処理などを実行（今回は５秒間待つだけ）
            Thread.sleep(forTimeInterval: 5)

            // 非同期処理などが終了したらメインスレッドでアニメーション終了
            DispatchQueue.main.async {
                // アニメーション終了
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        //カスタムセル
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        newsTableView.register(nib, forCellReuseIdentifier: "NewsCell")
       
        
        //リフレッシュコントローラー
        newsTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        
        reloadListDatas()
        
        newsTableView.reloadData()
        
    }
    @objc func update(){
        reloadListDatas()
        newsTableView.reloadData()
        // クルクルを止める
        refresh.endRefreshing()
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
