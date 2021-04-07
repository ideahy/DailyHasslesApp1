//
//  SendModel.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/03.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


//Firestoreの中にuserName,DHの数,日付を格納する


class SendModel {
    
    //パス
    let db = Firestore.firestore()
    
    
    func sendDailyHassles(userName:String,dailyHassles:String){
        
        //現在時刻を取得（GetDateModel）
        //falseにしたらソッコー終わりそう
        var date = GetDateModel.getTodayDate(slash: true)
        //        print(date)
        //collectionID(年月)
        for i in 0...1{
            if let slash = date.range(of: "/"){
                date.replaceSubrange(slash, with: "")
                print(date)
            }
        }
        let collectionID = date.prefix(6)
        //documentID(日付)
        let documentID = date.suffix(2)
        //当日の登録が複数回あった場合に、updateとして登録しないといけないので場合わけをする
        
        //アプリ初回起動時である場合は、(アプリ内に)todayとdoneを初期設定する
        //キー値"today"がアプリ内に存在しない場合
        if UserDefaults.standard.object(forKey: "today") == nil {
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "today")
            //今日は未送信(初期値)->"done"=1
            UserDefaults.standard.setValue(1, forKey: "done")
        }
        
        //①アプリ利用済　＋　本日未送信　＝　(FB)基本データ　＋　(アプリ)日付、done
        //("today"=前回利用日) != ("date"=DH記録ボタン押下日)
        if UserDefaults.standard.object(forKey: "today") as! String != date {
            //Firestoreに値を格納する
            db.collection("Users").document(Auth.auth().currentUser!.uid).collection(String(collectionID)).document(String(documentID)).setData(["userName":userName,"userID":Auth.auth().currentUser!.uid,"dailyHassles":dailyHassles,"date":Date().timeIntervalSince1970])
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "today")
            //今日は送信ずみ->"done"=0
            UserDefaults.standard.setValue(0, forKey: "done")
            
            //②アプリ利用済　＋　本日送信済　＝　(FB)DH　＋　(アプリ)日付
            //("today"=前回利用日) == ("date"=DH記録ボタン押下日)
            //("done" == 0) -> もうすでに今日のデータは送信ずみだよ
        }else if UserDefaults.standard.object(forKey: "today") as! String == date && UserDefaults.standard.object(forKey: "done") as! Int == 0 {
            //Firestoreの値をアップデートする
            db.collection("Users").document(Auth.auth().currentUser!.uid).collection(String(collectionID)).document(String(documentID)).updateData(["dailyHassles":dailyHassles])
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "today")
            //doneは変更を必要としない
            
            //③初回送信時
        }else{
            //Firestoreに値を格納する
            db.collection("Users").document(Auth.auth().currentUser!.uid).collection(String(collectionID)).document(String(documentID)).setData(["userName":userName,"userID":Auth.auth().currentUser!.uid,"dailyHassles":dailyHassles,"date":Date().timeIntervalSince1970])
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "today")
            //今日は送信ずみ->"done"=0
            UserDefaults.standard.setValue(0, forKey: "done")
            
        }
        //その下にdataが格納される
    }
    
    
    //キー値を変更する
    func sendResultForRank(userName:String,dailyHassles:String){
        
        //現在時刻を取得（GetDateModel）
        //falseにしたらソッコー終わりそう
        var date = GetDateModel.getTodayDate(slash: true)
        //        print(date)
        //collectionID(年月)
        for i in 0...1{
            if let slash = date.range(of: "/"){
                date.replaceSubrange(slash, with: "")
                print(date)
            }
        }
        let collectionID = date.prefix(6)
        //documentID(日付)
        let documentID = date.suffix(2)
        //当日の登録が複数回あった場合に、updateとして登録しないといけないので場合わけをする
        
        //アプリ初回起動時である場合は、(アプリ内に)todayとdoneを初期設定する
        //キー値"todayForRank"がアプリ内に存在しない場合
        if UserDefaults.standard.object(forKey: "todayForRank") == nil {
            //キー値"todayForRank"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "todayForRank")
            //今日は未送信(初期値)->"doneForRank"=1
            UserDefaults.standard.setValue(1, forKey: "doneForRank")
        }
        
        //①アプリ利用済　＋　本日未送信　＝　(FB)基本データ　＋　(アプリ)日付、done
        //("today"=前回利用日) != ("date"=DH記録ボタン押下日)
        if UserDefaults.standard.object(forKey: "todayForRank") as! String != date {
            //Firestoreに値を格納する
            db.collection("RankingData").document(Auth.auth().currentUser!.uid).setData(["userName":userName,"userID":Auth.auth().currentUser!.uid,"dailyHasslesForRank":dailyHassles])
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "todayForRank")
            //今日は送信ずみ->"done"=0
            UserDefaults.standard.setValue(0, forKey: "doneForRank")
            
            //②アプリ利用済　＋　本日送信済　＝　(FB)DH　＋　(アプリ)日付
            //("today"=前回利用日) == ("date"=DH記録ボタン押下日)
            //("done" == 0) -> もうすでに今日のデータは送信ずみだよ
        }else if UserDefaults.standard.object(forKey: "todayForRank") as! String == date && UserDefaults.standard.object(forKey: "doneForRank") as! Int == 0 {
            //Firestoreの値をアップデートする
            db.collection("RankingData").document(Auth.auth().currentUser!.uid).updateData(["userName":userName,"userID":Auth.auth().currentUser!.uid,"dailyHasslesForRank":dailyHassles])
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "todayForRank")
            //doneは変更を必要としない
            
            //③初回送信時
        }else{
            //Firestoreに値を格納する
            db.collection("RankingData").document(Auth.auth().currentUser!.uid).setData(["userName":userName,"userID":Auth.auth().currentUser!.uid,"dailyHasslesForRank":dailyHassles])
            //キー値"today"に取得した日付をアプリ内に保存する
            UserDefaults.standard.setValue(date, forKey: "todayForRank")
            //今日は送信ずみ->"done"=0
            UserDefaults.standard.setValue(0, forKey: "doneForRank")
            
        }
        //その下にdataが格納される
    }
}
