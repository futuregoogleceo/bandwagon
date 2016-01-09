//
//  AppDelegate.swift
//  Bandwagon
//
//  Created by Ilia Fishbein on 1/3/15.
//  Copyright (c) 2015 FishCorp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let want_settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil);
        let curr_settings = application.currentUserNotificationSettings();
        NSLog((curr_settings?.types.rawValue.description)!);
        if( curr_settings?.types != want_settings.types ) {
            application.registerUserNotificationSettings(want_settings);
        } else {
            application.registerForRemoteNotifications();
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application( application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        NSLog("SETTINGS");
        application.registerForRemoteNotifications();
    }

    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        // Data store file path
        let store_path = path_to_store()
        
        // Stored device token
        let d_token = NSData(contentsOfFile: store_path)
        if (d_token!.length == 0 || !d_token!.isEqualToData(deviceToken)) {
            deviceToken.writeToFile(store_path, atomically: true);
            
            let b64 = deviceToken.base64EncodedStringWithOptions([]);
            var bytes = [UInt8](count: deviceToken.length, repeatedValue: 0)
            deviceToken.getBytes(&bytes, length: deviceToken.length)
            
            let hexString = NSMutableString()
            for byte in bytes {
                hexString.appendFormat("%02x", UInt(byte))
            }
            NSLog(hexString as String);
            NSLog(b64);
        } else {
            let b64 = d_token!.base64EncodedStringWithOptions([]);
            var bytes = [UInt8](count: deviceToken.length, repeatedValue: 0)
            deviceToken.getBytes(&bytes, length: deviceToken.length)
            
            let hexString = NSMutableString()
            for byte in bytes {
                hexString.appendFormat("%02x", UInt(byte))
            }
            NSLog(hexString as String);
            NSLog(b64);
        }
        let device = UIDevice();
        NSLog(device.identifierForVendor!.UUIDString);
        NSLog(device.systemVersion);
        
    }
    
    func application( application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        NSLog("ERROR");
        NSLog(error.description);
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

