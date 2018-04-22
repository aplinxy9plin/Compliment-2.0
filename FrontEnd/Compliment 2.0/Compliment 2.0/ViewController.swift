//
//  ViewController.swift
//  Compliment 2.0
//
//  Created by Никита Аплин on 27.01.2018.
//  Copyright © 2018 Никита Аплин. All rights reserved.
//

import UIKit
import SwiftyJSON
//import Alamofire

struct testStruct {
    static var name = ""
    static var access_token = ""
    static var user_id = ""
    static var returner = ""
    static var girl_id = ["",""]
    static var girl_name = ["",""]
    static var xCor = 30
    static var yCor = 100
    static var friendName = ""
    static var buttonArray = [""]
    static var number = 0
    static var number1 = 0
    static var button = [UIButton]()
    static var label = [UILabel]()
    static var friend_list = ["Tomoto", "Rice", "Bread", "Milk", "Cheese"]
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
        
        let URL = NSURL(string: "http://192.168.0.102:3000/reg?access_token=\(access_token)&user_id=\(user_id)")
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
        let URL = NSURL(string: "http://192.168.0.102:3000/get_name?user_id=\(user_id)")
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
        //sendRequest()
    }
    @IBOutlet var switches: [UISwitch]!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ChooseViewController: UIViewController {
    
    @IBOutlet weak var link_input: UITextField!
    @IBAction func save_girl(_ sender: Any) {
        let id = link_input.text
        testStruct.girl_id[0] = id!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "https://api.vk.com/api.php?oauth=1&method=users.get&user_id=\(id)&v=5.74")
        var request = URLRequest(url: URL as! URL)
        var name = ""
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
            //print("responseString = \(String(describing: responseString!))")
            print("qq")
            var test = String(describing: responseString!)
            
            let json = JSON(data)
            testStruct.girl_name[0] = json["response"][0]["first_name"].string! + " " + json["response"][0]["last_name"].string!
            print(testStruct.girl_name[0])
            //name = json["response"]["items"][0]["first_name"].string + " " + json["response"]["items"][0]["last_name"].string
        }
        //self.viewDidLoad()
        task.resume()
        session.finishTasksAndInvalidate()
        //testStruct.girl_name[0] = "Анастасия Курдачева"
        addGirl(girl_id: id!,user_id: testStruct.user_id)
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavSecondViewController") as! NavSecondViewController
        self.present(registerViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 23)!]
    }
    @IBAction func girl1(_ sender: Any) {
        let id = "185701089"
        testStruct.girl_id[0] = id
        testStruct.girl_name[0] = "Анастасия Курдачева"
        addGirl(girl_id: id,user_id: testStruct.user_id)
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavSecondViewController") as! NavSecondViewController
        self.present(registerViewController, animated: true)
    }
    @IBAction func girl2(_ sender: Any) {
        let id = "151534106"
        testStruct.girl_id[1] = id
        testStruct.girl_name[1] = "Анастасия Родькина"
        addGirl1(girl_id: id,user_id: testStruct.user_id)
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavSecondViewController") as! NavSecondViewController
        self.present(registerViewController, animated: true)
     }
     @IBAction func girl3(_ sender: Any) {
        let id = "185701089"
        testStruct.girl_id[testStruct.number] = id
        addGirl(girl_id: id,user_id: testStruct.user_id)
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "NavSecondViewController") as! NavSecondViewController
        self.present(registerViewController, animated: true)
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
     }
    func addGirl(girl_id: String, user_id: String){
        //http://localhost:3000/girl_id?user_id=133087344&girl_id=153869259
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://192.168.0.102:3000/girl_id?user_id=\(user_id)&girl_id=\(girl_id)")
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
    func addGirl1(girl_id: String, user_id: String){
        //http://localhost:3000/girl_id?user_id=133087344&girl_id=153869259
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://192.168.0.102:3000/girl_id1?user_id=\(user_id)&girl_id=\(girl_id)")
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
}
struct AnimeJsonStuff: Decodable {
    let data: [AnimeDataArray]
}

struct AnimeLinks: Codable {
    var selfStr   : String?
    
    private enum CodingKeys : String, CodingKey {
        case selfStr     = "self"
    }
}
struct AnimeAttributes: Codable {
    var createdAt   : String?
    
    private enum CodingKeys : String, CodingKey {
        case createdAt     = "createdAt"
    }
}
struct AnimeRelationships: Codable {
    var links   : AnimeRelationshipsLinks?
    
    private enum CodingKeys : String, CodingKey {
        case links     = "links"
    }
}

struct AnimeRelationshipsLinks: Codable {
    var selfStr   : String?
    var related   : String?
    
    private enum CodingKeys : String, CodingKey {
        case selfStr     = "self"
        case related     = "related"
    }
}

struct AnimeDataArray: Codable {
    let id: String?
    let type: String?
    let links: AnimeLinks?
    let attributes: AnimeAttributes?
    let relationships: [String: AnimeRelationships]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case links = "links"
        case attributes = "attributes"
        case relationships = "relationships"
    }
}
class TestViewController: UITableViewController {
        var foods = testStruct.friend_list
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return foods.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = foods[indexPath.row]
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
            {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
            else
            {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        {
            if editingStyle == UITableViewCellEditingStyle.delete
            {
                foods.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            print(testStruct.friend_list)
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
}
protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
class YourGirlsViewController: UIViewController {
    
    @IBOutlet weak var plusButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //messages.getHistory
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "https://api.vk.com/method/messages.getHistory?user_id=151534106&v=5.74&count=5&access_token=\(testStruct.access_token)")
        var request = URLRequest(url: URL as! URL)
        var name = ""
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
            //print("responseString = \(String(describing: responseString!))")
            print("qq")
            var test = String(describing: responseString!)
            var p = 0
            let json = JSON(data)
            while(p < 5){
                //print(json["response"]["items"][0]["body"])
                var message = json["response"]["items"][p]["body"]
                if(json["response"]["items"][p]["out"] == 1){
                    print("out 1")
                    print("Бот: \(message)")
                    /*let label: UILabel = UILabel()
                    label.frame = CGRect(x: 72, y: 216, width: 236, height: 21)
                    label.textColor = UIColor.black
                    label.textAlignment = NSTextAlignment.center
                    label.text = "Анастасия Курдачева"
                    label.numberOfLines = 0
                    self.view.addSubview(label)*/
                }else{
                    print("\(testStruct.girl_name[0]): \(message)")
                }
                p += 1
            }
            //json["response"][0]["first_name"].string! + " " + json["response"][0]["last_name"].string!
            //print(json)
            //name = json["response"]["items"][0]["first_name"].string + " " + json["response"]["items"][0]["last_name"].string
        }
        //self.viewDidLoad()
        task.resume()
        session.finishTasksAndInvalidate()
        
        plusButton.layer.cornerRadius = 50
        plusButton.clipsToBounds = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 23)!]
        startBot(user_id: testStruct.user_id)
        if(testStruct.girl_id[1] == ""){
            //x = 16 y = 20 Пикча
            /*let imageView = UIImageView()
            imageView.frame = CGRect(x: 16, y: 20, width: 96, height: 91)
            imageView.image = #imageLiteral(resourceName: "Анастасия Курдачева.png")
            view.addSubview(imageView)
            let label: UILabel = UILabel()
            label.frame = CGRect(x: 120, y: 36, width: 135, height: 58)
            label.textColor = UIColor.black
            label.textAlignment = NSTextAlignment.center
            label.text = "Анастасия Курдачева"
            label.numberOfLines = 0
            view.addSubview(label)
            let button = UIButton()
            button.frame = CGRect(x: 299, y: 41, width: 52, height: 48)
            button.setImage(#imageLiteral(resourceName: "delete.png"), for: UIControlState.normal)
            view.addSubview(button)
            let buttonGo = UIButton()
            buttonGo.frame = CGRect(x: 0, y: 0, width: 291, height: 111)
            buttonGo.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            view.addSubview(buttonGo)*/
        }else{
            //Курдачева
            /*let imageView = UIImageView()
            imageView.frame = CGRect(x: 16, y: 20, width: 96, height: 91)
            imageView.image = #imageLiteral(resourceName: "Анастасия Курдачева.png")
            view.addSubview(imageView)
            let label: UILabel = UILabel()
            label.frame = CGRect(x: 120, y: 36, width: 135, height: 58)
            label.textColor = UIColor.black
            label.textAlignment = NSTextAlignment.center
            label.text = "Анастасия Курдачева"
            label.numberOfLines = 0
            view.addSubview(label)
            let button = UIButton()
            button.frame = CGRect(x: 299, y: 41, width: 52, height: 48)
            button.setImage(#imageLiteral(resourceName: "delete.png"), for: UIControlState.normal)
            view.addSubview(button)
            let buttonGo = UIButton()
            buttonGo.frame = CGRect(x: 0, y: 0, width: 291, height: 111)
            buttonGo.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            view.addSubview(buttonGo)*/
            
           
        }
    }
    @objc func buttonAction(){
        print("Go to settings")
        performSegue(withIdentifier: "MainViewController", sender: nil)
    }
    func startBot(user_id: String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://192.168.0.102:3000/send_message?user_id=\(user_id)")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
