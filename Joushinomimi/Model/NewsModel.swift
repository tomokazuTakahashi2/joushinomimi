//
//  NewsModel.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/03/24.
//  Copyright © 2020 takahashi. All rights reserved.
//

import Foundation

struct NewsModel: Codable  {
    //日付
    var content: String = ""
    var dateString: String{
     //NSDateFormatterのインスタンスを生成
     let formatter: DateFormatter = DateFormatter()
     
         //受け取るフォーマットを設定
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
         //正常にDate型に変換できるか確認
         if let date = formatter.date(from: content){
             //表示するフォーマットを指定
             formatter.dateFormat = "yyyy/MM/dd HH:mm"
             //String型に変換を行い、返す
             let str = formatter.string(from: date)
             return str
         }
    //万が一失敗した場合は、そのままdateを返す
        return content
    }
    
    //著者名
    var author: String = ""
    
    //記事名
    var title: SampleTitleModel = SampleTitleModel()
    struct SampleTitleModel: Codable {
        var rendered: String = ""
    }
//    //イメージ
//    var urlToImage: String = ""
//    var urlToImageString = valueDictionary["urlToImage"] as? String
//    var urlToImage = UIImage(data: Data(base64Encoded: urlToImageString!, options: .ignoreUnknownCharacters)!)
    //記事本文
    var description: String = ""
    //出典
    var name: String = ""
    //URL
    var link: String = ""
}
