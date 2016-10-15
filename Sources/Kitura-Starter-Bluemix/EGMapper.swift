//
//  EGMapper.swift
//  Kitura-Starter-Bluemix
//
//  Created by Nero Zuo on 16/10/15.
//
//

import Foundation
import SwiftyJSON

struct EGMapper {
  let anger: Double
  let contempt: Double
  let disgust: Double
  let fear: Double
  let happiness: Double
  let neutral: Double
  let sadness: Double
  let surprise: Double
  
  init(json: JSON) {
    anger = json["anger"].doubleValue
    contempt = json["contempt"].doubleValue
    disgust = json["disgust"].doubleValue
    fear = json["fear"].doubleValue
    happiness = json["happiness"].doubleValue
    neutral = json["neutral"].doubleValue
    sadness = json["sadness"].doubleValue
    surprise = json["surprise"].doubleValue
  }
  
  func mapper() -> (Double, Double, Double) {
    let red = (anger + contempt)*255
    let green = (disgust + fear)*255
    let blue = (happiness + neutral + surprise)*255
    return (red, green, blue)
  }
}
