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
    
    router.post("/control-light", handler: controlLight)
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
    var data = Data()
    try request.read(into: &data)
    EmotionRecognition.getEmotion(from: data) { (inData, inReponse) in
      reponse.headers["Content-Type"] = "application/json; charset=utf-8"
      let jsonResponse = JSON(data: inData!)
      try! reponse.status(.OK).send(json: jsonResponse).end()
    }
  }
  
  public func controlLight(request: RouterRequest, reponse: RouterResponse, next: @escaping ()-> Void) throws {
    Log.debug("Get ")
    let parameters = request.parameters
    let lightid = parameters["id"]
    let brightness = Double(parameters["brightness"]!)
    
    var jsonResponse = JSON([:])
    jsonResponse["result"] = "success"
    
    try reponse.status(.OK).send(json: jsonResponse).end()
  }

}
