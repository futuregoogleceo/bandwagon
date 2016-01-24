//
//  ViewController.swift
//  Bandwagon
//
//  Created by Ilia Fishbein on 1/3/15.
//  Copyright (c) 2015 FishCorp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func RegisterDevice(sender: AnyObject) {
        
        let email_addr = email.text
        let phone_num  = phone.text
        
        // Data store file path
        let store_path = path_to_store()
        
        // Stored device token
        let d_token = NSData(contentsOfFile: store_path)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://sandbox.fishbein.me/register-token")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let device = UIDevice()
        let params = ["email":email_addr!, "phone":phone_num!, "type":"iPhone8,1 iOS 9.2", "token":d_token!.base64EncodedStringWithOptions([]), "idfv":device.identifierForVendor!.UUIDString] as Dictionary<String, String>
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
        } catch let err as NSError {
            NSLog(err.description)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil){
                NSLog("An error occurred in dataTaskWithRequest: " + error!.description);
                return;
            }
            NSLog("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("Body: \(strData)")
            var json:NSDictionary? = nil
            do {
                json = try NSJSONSerialization.JSONObjectWithData((data)!, options: .MutableLeaves) as? NSDictionary
            } catch let err as NSError {
                NSLog("Error parsing JSON")
                NSLog(err.description)
            }
            
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                let success = parseJSON["success"] as? Int
                NSLog("Succes: \(success)")
            } else {
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                NSLog("Error could not parse JSON: \(jsonStr)")
            }
        })
        
        task.resume()
    }
    
    func path_to_store()->String{
        let filemanager = NSFileManager.defaultManager()
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/data_store.txt")
        
        if (!filemanager.fileExistsAtPath(destinationPath as String)) {
            filemanager.createFileAtPath(destinationPath as String, contents: nil, attributes: nil)
        }
        
        return destinationPath as String
    }
}

