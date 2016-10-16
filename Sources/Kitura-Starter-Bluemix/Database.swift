//
//  Database.swift
//  Kitura-Starter-Bluemix
//
//  Created by Nero Zuo on 16/10/15.
//
//

import Foundation

enum HardWareType: String {
  case light = "light"
}

class Database {
  static let shareInstance = Database()
  
  var lightsStatus: [String: (HardWareType, Double)] = [:]
  
  var happiness: Double = 0
  var sadness: Double = 0
  var hasTokenPhoto = false
  
  private init() {
    lightsStatus = [:]
    lightsStatus["1"] = (.light, 0)
  }
  
}
