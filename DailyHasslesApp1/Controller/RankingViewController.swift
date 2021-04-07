//
//  RankingViewController.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/07.
//

import UIKit
import FirebaseAuth

class RankingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,GetRankProtocol {
    
    

    @IBOutlet weak var rankingTableView: UITableView!
    //ランキングをロード
    var loadModel = LoadModel()
    var rankDataArray = [RankData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        //ランキングデータをロード
        //getRankProtocolが持っているメソッドは自分が呼ぶ
        loadModel.getRankProtocol = self
        //自分だけではなくて他の人のデータも取ってくることができる
        //自分のUIDを利用する意味は自分が何番目にいるかを判断するため
        loadModel.loadRankingData(userID: Auth.auth().currentUser!.uid)
        //
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = .clear
        let rankLabel = cell.contentView.viewWithTag(1) as! UILabel
        rankLabel.text = String(indexPath.row + 1)
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = rankDataArray[indexPath.row].userName
        let dailyHasslesLabel = cell.contentView.viewWithTag(3) as! UILabel
        dailyHasslesLabel.text = rankDataArray[indexPath.row].userDailyHassles
        
        if rankDataArray[indexPath.row].userID == Auth.auth().currentUser?.uid{
            cell.contentView.backgroundColor = .systemTeal
        }
        return cell
    }
    
    
    func getRankData(dataArray: [RankData]) {
        rankDataArray = dataArray
        rankingTableView.reloadData()
    }
}
