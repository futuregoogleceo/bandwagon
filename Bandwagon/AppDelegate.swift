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
        var types = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound;
        var settings = application.currentUserNotificationSettings();
        NSLog(settings.types.rawValue.description);
        if( settings.types != types ) {
            settings = UIUserNotificationSettings(forTypes: types, categories: nil);
            application.registerUserNotificationSettings(settings);
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

    func application( application: UIApplication!, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!) {
        NSLog("SETTINGS");
        application.registerForRemoteNotifications();
    }

    func application( application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData! ) {
        NSLog("REGISTERED");
        var thePath = "/u/data_store.txt";
        var data = NSData(contentsOfFile: thePath)!;
        NSLog(data.base64EncodedStringWithOptions(nil));
        if (data.length == 0 || data.isEqualToData(deviceToken) == false) {
            deviceToken.writeToFile(thePath, atomically: true);
        
            var b64 = deviceToken.base64EncodedStringWithOptions(nil);
            NSLog(b64);
            var device = UIDevice();
            NSLog(device.identifierForVendor.UUIDString);
        }
        
    }
    
    func application( application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        NSLog("ERROR");
        NSLog(error.description);
    }
}

