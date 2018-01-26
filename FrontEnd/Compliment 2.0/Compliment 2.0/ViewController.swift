//
//  ViewController.swift
//  Compliment 2.0
//
//  Created by Никита Аплин on 27.01.2018.
//  Copyright © 2018 Никита Аплин. All rights reserved.
//

import UIKit
import Alamofire

struct testStruct {
    static var name = ""
    static var access_token = ""
    static var user_id = ""
    static var returner = ""
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(testStruct.access_token != "" && testStruct.user_id != ""){
            sendRequest(access_token: testStruct.access_token, user_id: testStruct.user_id)
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                self.returner()
            }
            getName(user_id: testStruct.user_id)
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                print(testStruct.name)
            }
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func returner() -> String{
        return testStruct.returner
    }
    func sendRequest(access_token: String, user_id: String){
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request (POST http://13.95.174.54/server/test.php)
         */
        
        let URL = NSURL(string: "http://127.0.0.1:3000/reg?access_token=\(access_token)&user_id=\(user_id)")
        var request = URLRequest(url: URL as! URL)
        request.httpMethod = "GET"
        /* Start a new Task */
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString!))")
            testStruct.returner = String(describing: responseString!)
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    func getName(user_id: String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://127.0.0.1:3000/get_name?user_id=\(user_id)")
        var request = URLRequest(url: URL as! URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString!))")
            testStruct.name = String(describing: responseString!)
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class WebViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*request("http://jsonplaceholder.typicode.com/posts").responseJSON { response in
         print(response)
         }*/
        print("STRUCT = \(testStruct.access_token)")
        webView.delegate=self
        let url=URL(string:"https://oauth.vk.com/authorize?client_id=5719989&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=messages,offline&response_type=token&v=5.63")
        let urlRequest=URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    func webViewDidFinishLoad(_ web: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let urlString = webView.request!.url!.absoluteString
        print("MY WEBVIEW URL: \(urlString)")
        if urlString.contains("access_token") {
            print("I have token")
            let access_token = urlString.components(separatedBy: "access_token=")[1].components(separatedBy: "&")[0]
            let user_id = urlString.components(separatedBy: "user_id=")[1].components(separatedBy: "&")[0]
            print(access_token)
            testStruct.access_token = access_token
            testStruct.user_id = user_id
            //self.dismiss(animated: true, completion: nil)
            //let test = WebViewController()
            //self.show(test, sender:true)
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
            self.present(registerViewController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
