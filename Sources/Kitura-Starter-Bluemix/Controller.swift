/**
* Copyright IBM Corporation 2016
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
**/

import Kitura
import SwiftyJSON
import LoggerAPI
import CloudFoundryEnv
import Foundation

public class Controller {

  let router: Router
  let appEnv: AppEnv

  var port: Int {
    get { return appEnv.port }
  }

  var url: String {
    get { return appEnv.url }
  }

  init() throws {
    appEnv = try CloudFoundryEnv.getAppEnv()

    // All web apps need a Router instance to define routes
    router = Router()

    // Serve static content from "public"
    router.all("/", middleware: StaticFileServer())

    // Basic GET request
    router.get("/hello", handler: getHello)

    // Basic POST request
    router.post("/hello", handler: postHello)

    // JSON Get request
    router.get("/json", handler: getJSON)
    
    // JSON Hello world
    router.get("/helloworld", handler: getHelloWorld)
    
    router.post("/emotion", handler: emotionRecognization)
    
    router.get("/control-light", handler: controlLight)
    
    router.post("/light-brightness", handler: brightness)
    
    router.post("/all-light-brightness", handler: allBrightness)
    
    router.get("/emotion-json", handler: getEmotion)
    
    router.get("/ruff-brightness", handler: ruffBrightness)
  }

  public func getHello(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
    Log.debug("GET - /hello route handler...")
    response.headers["Content-Type"] = "text/plain; charset=utf-8"
    try response.status(.OK).send("Hello from Kitura-Starter-Bluemix!").end()
  }

  public func postHello(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
    Log.debug("POST - /hello route handler...")
    response.headers["Content-Type"] = "text/plain; charset=utf-8"
    if let name = try request.readString() {
      try response.status(.OK).send("Hello \(name), from Kitura-Starter-Bluemix!").end()
    } else {
      try response.status(.OK).send("Kitura-Starter-Bluemix received a POST request!").end()
      
    }
  }

  public func getJSON(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
    Log.debug("GET - /json route handler...")
    response.headers["Content-Type"] = "application/json; charset=utf-8"
    var jsonResponse = JSON([:])
    jsonResponse["framework"].stringValue = "Kitura"
    jsonResponse["applicationName"].stringValue = "Kitura-Starter-Bluemix"
    jsonResponse["company"].stringValue = "IBM"
    jsonResponse["organization"].stringValue = "Swift @ IBM"
    jsonResponse["location"].stringValue = "Austin, Texas"
    try response.status(.OK).send(json: jsonResponse).end()
  }
  
  public func getHelloWorld(request: RouterRequest, response: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("GET - /json route handler...")
    var jsonResponse = JSON([:])
    jsonResponse["test"].stringValue = "HelloWorld"
//    let url = "https://portalstoragewuprod.azureedge.net/emotion/recognition3-thumbnail.jpg"
//    EmotionRecognition.getEmotion(from: url)
    try response.status(.OK).send(json: jsonResponse).end()
  }
  
  public func emotionRecognization(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("POST - /json route handler...")
    if let _ = request.body {
      print("have body")
    }else {
      print("have no body")
    }
    var jsonRespone = JSON([:])
    jsonRespone["hello"].stringValue = "world"
    try! reponse.status(.OK).send(json: jsonRespone).end()
  }
  
  public func controlLight(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("Get")
    let parameters = request.queryParameters
    let lightid = parameters["id"]!
    let brightness = Double(parameters["brightness"]!)!
    reponse.headers["Content-Type"] = "application/json; charset=utf-8"
    Database.shareInstance.lightsStatus[lightid] = (HardWareType.light, brightness)
    
    var jsonResponse = JSON([:])
    jsonResponse["result"] = "success"
    
    try reponse.status(.OK).send(json: jsonResponse).end()
  }
  
  public func brightness(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("post")
    let id = request.cookies["id"]!.value
    let value = Database.shareInstance.lightsStatus[id]?.1 ?? 0
    reponse.headers["Content-Type"] = "application/json; charset=utf-8"
    var jsonResponse = JSON([:])
    
    if Database.shareInstance.hasTokenPhoto == true {
      jsonResponse["hasTokenPhoto"].boolValue = Database.shareInstance.hasTokenPhoto
      jsonResponse["happiness"].doubleValue = Database.shareInstance.happiness
      jsonResponse["sadness"].doubleValue = Database.shareInstance.sadness
      let happiness = Database.shareInstance.happiness
      let saidness = Database.shareInstance.sadness
      if happiness > saidness {
        Database.shareInstance.lightsStatus[id] = (.light, 100)
      }else {
        Database.shareInstance.lightsStatus[id] = (.light, 0)
      }
      Database.shareInstance.hasTokenPhoto = false
    }
    jsonResponse["value"].doubleValue = value
    
    try reponse.status(.OK).send(json: jsonResponse).end()
  }
  
  public func ruffBrightness(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("post")
    let id = request.queryParameters["id"]!
    let value = Database.shareInstance.lightsStatus[id]?.1 ?? 0
    reponse.headers["Content-Type"] = "application/json; charset=utf-8"
    var jsonResponse = JSON([:])
    
    if Database.shareInstance.hasTokenPhoto == true {
      jsonResponse["hasTokenPhoto"].boolValue = Database.shareInstance.hasTokenPhoto
      jsonResponse["happiness"].doubleValue = Database.shareInstance.happiness
      jsonResponse["sadness"].doubleValue = Database.shareInstance.sadness
      let happiness = Database.shareInstance.happiness
      let saidness = Database.shareInstance.sadness
      if happiness > saidness {
        Database.shareInstance.lightsStatus[id] = (.light, 100)
      }else {
        Database.shareInstance.lightsStatus[id] = (.light, 0)
      }
      Database.shareInstance.hasTokenPhoto = false
    }
    jsonResponse["value"].doubleValue = value
    
    try reponse.status(.OK).send(json: jsonResponse).end()
  }
  
  
  public func allBrightness(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("allBrightness post")
    let allBrights = Database.shareInstance.lightsStatus
    var dic:[String:Double] = [:]
    for (key, (_, value)) in allBrights {
      dic[key] = value
    }
    reponse.headers["Content-Type"] = "application/json; charset=utf-8"
    let jsonResponse = JSON(dic)
    try reponse.status(.OK).send(json: jsonResponse).end()
  }
  
  public func getEmotion(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("Get Emotion")
    if let happiness = request.queryParameters["happiness"], let sadness = request.queryParameters["sadness"] {
      if let happiness = Double(happiness), let sadness = Double(sadness) {
        Database.shareInstance.happiness = happiness
        Database.shareInstance.happiness = sadness
        Database.shareInstance.hasTokenPhoto = true
        var jsonReponse = JSON([:])
        jsonReponse["result"].stringValue = "success"
        reponse.headers["Content-Type"] = "application/json; charset=utf-8"
        try reponse.status(.OK).send(json: jsonReponse).end()
      }
    }
    var jsonReponse = JSON([:])
    jsonReponse["result"].stringValue = "failure"
    reponse.headers["Content-Type"] = "application/json; charset=utf-8"
    try reponse.status(.OK).send(json: jsonReponse).end()
    
  }
  
  
  
}
