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
        
        let URL = NSURL(string: "http://46.236.128.17:3000/reg?access_token=\(access_token)&user_id=\(user_id)")
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
        let URL = NSURL(string: "http://46.236.128.17:3000/get_name?user_id=\(user_id)")
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
        let URL = NSURL(string: "http://46.236.128.17:3000/girl_id?user_id=\(user_id)&girl_id=\(girl_id)")
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
        let URL = NSURL(string: "http://46.236.128.17:3000/girl_id1?user_id=\(user_id)&girl_id=\(girl_id)")
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

class TestViewController: UIViewController {
    var arrayImageLink = ["https://pp.userapi.com/c841137/v841137846/37d98/iL2IvM3znFw.jpg","https://pp.userapi.com/c841028/v841028970/64210/kQz2tKZ3plE.jpg"]
    var arrayName = ["Никита Усольцев","Дарья Ренжигло"]
    var myImage = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loadedefsadfasfas")
        myImage.layer.cornerRadius = 50
        myImage.clipsToBounds = true
        while(testStruct.number <= 1){
            testStruct.friendName = arrayName[testStruct.number]
            collect(url: arrayImageLink[testStruct.number])
            testStruct.xCor += 100
            testStruct.number += 1
        }
        //testStruct.friendName = arrayName[0]
        //collect(url: arrayImageLink[testStruct.number])
    }
    func viewButton(){
        //print(testStruct.label[testStruct.number].text)
        view.addSubview(testStruct.button[testStruct.number])
        view.addSubview(testStruct.label[testStruct.number])
    }
    func collect(url: String){
        if let url = URL(string: url) {
            myImage.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    @objc func buttonAction(sender: UIButton!) {
        collect(url: arrayImageLink[0])
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.myImage.image = UIImage(data: data)
                // var button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
                var button = UIButton()
                button.frame = CGRect(x: testStruct.xCor, y: testStruct.yCor, width: 100, height: 100)
                button.setImage(self.myImage.image, for: .normal)
                button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                testStruct.button.append(button)
                //self.view.addSubview(button)
                var label: UILabel = UILabel()
                label.frame = CGRect(x: testStruct.xCor, y: (testStruct.yCor + 110), width: 110, height: 50)
                label.textColor = UIColor.black
                label.textAlignment = NSTextAlignment.center
                label.text = testStruct.friendName
                label.numberOfLines = 0
                testStruct.label.append(label)
                //self.view.addSubview(label)
            }
            self.viewButton()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class YourGirlsViewController: UIViewController {
    
    @IBOutlet weak var plusButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            //Родькина
            let imageView1 = UIImageView()
            imageView1.frame = CGRect(x: 16, y: 145, width: 96, height: 91)
            imageView1.image = #imageLiteral(resourceName: "Анастасия Родькина.png")
            view.addSubview(imageView1)
            let label1: UILabel = UILabel()
            label1.frame = CGRect(x: 120, y: 161, width: 135, height: 58)
            label1.textColor = UIColor.black
            label1.text = "Анастасия Родькина"
            label1.font = UIFont(name: "Helvetica", size: 23)
            label1.numberOfLines = 0
            view.addSubview(label1)
            let button1 = UIButton()
            button1.frame = CGRect(x: 299, y: 166, width: 52, height: 48)
            button1.setImage(#imageLiteral(resourceName: "delete.png"), for: UIControlState.normal)
            view.addSubview(button1)
            let buttonGo11 = UIButton()
            buttonGo11.frame = CGRect(x: 0, y: 125, width: 291, height: 111)
            buttonGo11.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            view.addSubview(buttonGo11)
        }
    }
    @objc func buttonAction(){
        print("Go to settings")
        performSegue(withIdentifier: "MainViewController", sender: nil)
    }
    func startBot(user_id: String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "http://46.236.128.17:3000/send_message?user_id=\(user_id)")
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
