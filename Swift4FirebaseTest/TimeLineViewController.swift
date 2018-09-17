//
//  TimeLineViewController.swift
//  Swift4FirebaseTest
//
//  Created by 渡辺健一 on 2018/09/17.
//  Copyright © 2018年 渡辺健一. All rights reserved.
//

import UIKit
import Firebase

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var displayName = String()
    var comment = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    let refleshControl = UIRefreshControl()
    
    var userName_Array = [String]()
    var comment_Array = [String]()
    
    var posts = [Post]()
    var posst = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refleshControl.attributedTitle = NSAttributedString(string: "取得して更新")
        refleshControl.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        
        tableView.addSubview(refleshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //データを取得する
        fetchPost()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //データを取得した分、Cellを増やす
        return posts.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        //userNameにあるindexPath.row番目を取得
        userNameLabel.text = self.posts[indexPath.row].userName
        
        let commentLabel = cell.viewWithTag(2) as! UILabel
        //commentにあるindexPath.row番目を取得
        commentLabel.text = self.posts[indexPath.row].comment
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
        
    }
    
    @objc func reflesh(){
        
        //取得して更新されたときに呼ばれる箇所
        fetchPost()
        //reloadを止める
        refleshControl.endRefreshing()
        
    }
    
    //Firebase内からデータを取得
    func fetchPost(){
        
        //データ取得時の前処理
        self.userName_Array = [String]()
        self.comment_Array = [String]()
        self.posst = Post()
        
        //GoogleService-Info.plist内からデータを取得
        let ref = Database.database().reference()
        //Firebase内から、取得するデータの種類を指定する
        ref.child("post").observeSingleEvent(of: .value) { (snap,error) in
            
            let postsSnap = snap.value as?[String:NSDictionary]
            
                if postsSnap == nil{
                    return
                }
                
                self.posts = [Post]()
            
            //Firebase内のデータをある分だけ取得
                for(_,post) in postsSnap!{
                    
                    self.posts = [Post()]
                    
                    if let comment = post["comment"] as? String,
                       let userName = post["userName"] as? String{
                        
                        //Firebase内のデータ
                        self.posst.comment = comment
                        self.posst.userName = userName
                        
                        //Firebase内のデータを配列で取得
                        self.comment_Array.append(self.posst.comment)
                        self.userName_Array.append(self.posst.userName)
                        
                    }
                    
                    self.posts.append(self.posst)
                    
                }
                
                self.tableView.reloadData()
                
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
