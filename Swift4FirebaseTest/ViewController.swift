//
//  ViewController.swift
//  Swift4FirebaseTest
//
//  Created by 渡辺健一 on 2018/09/17.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit
import LineSDK

class ViewController: UIViewController,LineSDKLoginDelegate {
    
    var displayName = String()
    var pictureURL = String()
    var pictureURLString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LineSDKLogin.sharedInstance().delegate = self
        
    }
    
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        
        //displayNameを取得
        if let displayName = profile?.displayName{
            
            self.displayName = displayName
            
        }
        
        //pictureURLを取得
        if let pictureURL = profile?.pictureURL{
            
            self.pictureURLString = pictureURL.absoluteString
            
        }
        
        //上記で取得したものをUserDefaultsへ保存
        UserDefaults.standard.set(self.displayName, forKey: "displayName")
        UserDefaults.standard.set(self.pictureURLString, forKey: "pictureURLString")
        
        //遷移先を記述
        performSegue(withIdentifier: "next", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func login(_ sender: Any) {
        
        //Lineを使用する許可を取る
        LineSDKLogin.sharedInstance().start()
        
    }
    
}

