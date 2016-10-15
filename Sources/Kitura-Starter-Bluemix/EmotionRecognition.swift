//
//  EmotionRecognition.swift
//  Kitura-Starter-Bluemix
//
//  Created by Nero Zuo on 16/10/15.
//
//

import Foundation
import SwiftyJSON
import KituraNet

struct ERConfig {
  static let urlPathStr = "https://api.projectoxford.ai/emotion/v1.0/recognize"
  static let key = "436247384bac413cabcb2c48af86bacd"
}

struct EmotionRecognition {
  static func getEmotion(from urlStr: String, completionHandler: @escaping (Data?, URLResponse?) -> Void) {
    let session = URLSession.shared
    let url = URL(string: ERConfig.urlPathStr)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(ERConfig.key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    request.httpBody = try! JSONSerialization.data(withJSONObject: ["url": urlStr], options: [])
    let task = session.dataTask(with: (request as URLRequest)) { (data, reponse, error) in
      completionHandler(data, reponse)
    }
    task.resume()
  }
  
  static func getEmotion(from data: Data, completionHandler: @escaping (Data?, URLResponse?) -> Void) {
    let session = URLSession.shared
    let url = URL(string: ERConfig.urlPathStr)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
    request.addValue(ERConfig.key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    request.httpBody = data
    let task = session.dataTask(with: (request as URLRequest)) { (data, reponse, error) in
      completionHandler(data, reponse)
    }
    task.resume()
  }
}
