//
//  ViewController.swift
//  Compliment 2.0
//
//  Created by Никита Аплин on 27.01.2018.
//  Copyright © 2018 Никита Аплин. All rights reserved.
//

import UIKit
//import Alamofire

struct testStruct {
    static var name = ""
    static var access_token = ""
    static var user_id = ""
    static var returner = ""
    static var girl_id = ""
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(testStruct.access_token != "" && testStruct.user_id != ""){
            sendRequest(access_token: testStruct.access_token, user_id: testStruct.user_id)
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                self.returner()
            }
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                self.getName(user_id: testStruct.user_id)
            }
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func returner() -> String{
        if(testStruct.returner == "New"){
            // New
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
            self.present(registerViewController, animated: true)
        }else{
            // Used
            let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavSecondViewController") as! NavSecondViewController
            self.present(registerViewController, animated: true)
        }
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
        let url=URL(string:"https://oauth.vk.com/authorize?client_id=6349359&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=messages,offline&response_type=token&v=5.63")
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

class BoyQuestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 23)!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    @IBOutlet var switches: [UISwitch]!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ChooseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 23)!]
    }
    @IBAction func girl1(_ sender: Any) {
        let id = "185701089"
        testStruct.girl_id = id
        addGirl(girl_id: id,user_id: testStruct.user_id)
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavSecondViewController") as! NavSecondViewController
        self.present(registerViewController, animated: true)
    }
    /*@IBAction func girl2(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl3(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl4(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl5(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl6(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl7(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl8(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }
     @IBAction func girl9(_ sender: Any) {
     var id = "2281337"
     addGirl(girl_id: id,user_id: testStruct.user_id)
     }*/
    func addGirl(girl_id: String, user_id: String){
        //http://localhost:3000/girl_id?user_id=133087344&girl_id=153869259
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://127.0.0.1:3000/girl_id?user_id=\(user_id)&girl_id=\(girl_id)")
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
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class BoobsViewController: UIViewController {
    
    @IBOutlet weak var boobs: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBOutlet weak var image: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class YourGirlsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 23)!]
        startBot(user_id: testStruct.user_id)
    }
    func startBot(user_id: String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://127.0.0.1:3000/send_message?user_id=\(user_id)")
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
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class MainViewController: UIViewController {
    
    @IBOutlet weak var textFieldLinkOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let URL_IMAGE = URL(string: "http://www.simplifiedtechy.net/wp-content/uploads/2017/07/simplified-techy-default.png")
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        self.imageView?.image = image
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()
        //textFieldLinkOutlet.font: UIFont(name: "Helvetica", size: 20)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 23)!]
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
