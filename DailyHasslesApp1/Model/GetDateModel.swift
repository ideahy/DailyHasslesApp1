//
//  GetDateModel.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/03.
//


//今日の日付を取得するモデル


import Foundation

class GetDateModel {
    
    //キー値指定でユーザーデータにアクセスできる
//    var getUserDataModel = GetUserDataModel()
    
    //呼出->String型で今日の日付を返す
    // "/"有無で使い分ける->欲しい場合は"True"を引数に指定する
    static func getTodayDate(slash:Bool)->String {
        //定数fとして日付を加工する
        let f = DateFormatter()
        //時間表記は取得しない
        f.timeStyle = .none
        //日付で取れるものは全て取得する
        f.dateStyle = .full

        // "/"有で返す場合
        if slash == true {
            f.dateFormat = "yyyy/MM/dd"
        }
        
        //日本時間に設定する
        f.locale = Locale(identifier: "ja_JP")
        //現在の日付を取得する
        let now = Date()
        //現在の日付->プロパティを変更->String型で返す
        return f.string(from: now)
    }
    
}
