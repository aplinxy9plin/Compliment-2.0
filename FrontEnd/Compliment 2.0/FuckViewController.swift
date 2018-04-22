//
//  FuckViewController.swift
//  Compliment 2.0
//
//  Created by Никита Аплин on 22.04.2018.
//  Copyright © 2018 Никита Аплин. All rights reserved.
//

import UIKit
import SwiftyJSON

class FuckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //sendRequest()
    func sendRequest() {
        
        /*let URLParams = [
         "oauth": "1",
         "method": "friends.get",
         "user_id": "90327755",
         "count": "50",
         "order": "name",
         "name_case": "ins",
         "v": "5.74",
         "fields": "city,domain,photo_100,domain, sex, bdate, city, country, timezone, photo_50, photo_100, photo_200_orig, has_mobile, contacts, education, online, relation, last_seen, status, can_write_private_message, can_see_all_posts, can_post, universities",
         ]*/
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let URL = NSURL(string: "https://api.vk.com/api.php?oauth=1&method=friends.get&user_id=90327755&count=50&order=name&name_case=ins&v=5.74&fields=city,domain")
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
            var i = 0
            while i < 50{
                testStruct.friend_list[i] = json["response"]["items"][i]["first_name"].string! + " " + json["response"]["items"][i]["last_name"].string!
            }
            //name = json["response"]["items"][0]["first_name"].string + " " + json["response"]["items"][0]["last_name"].string
        }
        //self.viewDidLoad()
        task.resume()
        session.finishTasksAndInvalidate()
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
