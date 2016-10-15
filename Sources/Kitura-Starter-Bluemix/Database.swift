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
  
  private init() { }
  
}
