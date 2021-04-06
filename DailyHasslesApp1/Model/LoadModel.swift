//
//  LoadModel.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/05.
//

import Foundation
import FirebaseFirestore


//コントローラに通知する用のプロトコル
protocol GetDataProtocol {
    //このメソッドを呼ぶタイミングは？？？→受信が完了した後
    func getData(dataArray:[PersonalData])
}

//自分のデータをチャートに反映させるためにFSからデータを取得する


class LoadModel{
    
    let db = Firestore.firestore()
    //年月から取得したデータを格納する配列
    var personalDataArray = [PersonalData]()
    //LoadModelをコントローラでイニシャライザしたときにプロトコルにアクセスができる
    var getDataProtocol:GetDataProtocol?
    
    //データ取得先＝指定する年月collection
    func loadMyRecordData(userID:String,yearMonth:String,day:String){
        db.collection("Users").document(userID).collection(yearMonth).addSnapshotListener { (snapShot, error) in
            
            //チャート用に取得した月のユーザーデータを格納するための初期化
            self.personalDataArray = []
            if error != nil{
                return
            }
            //指定月のユーザーデータがあれば格納
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    //指定日のユーザーデータを格納
                    let data = doc.data()
                    //data内の空判定
                    if let userID = data["userID"] as? String, let userName = data["userName"] as? String, let dailyHassles = data["dailyHassles"] as? String, let date = data["date"] as? Double{
                        //格納されていることが確認できれば変数に代入
                        let newPersonalData = PersonalData(userID: userID, userName: userName, dailyHassle: dailyHassles, date: date)
                        //配列の中に変数を格納？？？ -> 全部入ったらチャートに持ってく？？？
                        //受信できたみたいだが、コントローラ側にそれを通知したい->プロトコル利用
                        self.personalDataArray.append(newPersonalData)
                    }
                }
            }
            //全て入った最新版がここにある
            //全ての読み込みが完了したら、このメソッドが呼ばれる
            //場所：チャートビューコントローラに記載している
            self.getDataProtocol?.getData(dataArray: self.personalDataArray)
        }
    }
}
