//
//  NewsViewController.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/03/22.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit
import Alamofire


class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Alamofire
        AF.request("https://newsapi.org/v2/top-headlines?country=jp&apiKey=59288c383f6b40b1969c83c8fae0f0be").response { response in
            debugPrint(response)
        }
//        AF.request("http://newsapi.org/v2/top-headlines?country=jp&apiKey=59288c383f6b40b1969c83c8fae0f0be").response { response in
//
//
//            print("Request: \(String(describing: response.request))")
//            print("Response: \(String(describing: response.response))")
//            print("Result: \(response.result)")
//
//            if let json = response.result{
//                print("JSON: \(json)")
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
//                print("Data \(utf8Text)")
//            }
//        }
    }
    //APIキー　59288c383f6b40b1969c83c8fae0f0be
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
