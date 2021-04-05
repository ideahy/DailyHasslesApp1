//
//  GetUserDataModel.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/03.
//

import Foundation


//キー値を指定して呼出->該当箇所（アプリ内）に保存されているデータを全取得できる


class GetUserDataModel {
    //文字列型のキー値"〇〇"を引数に結果を文字列型で返す
    static func getUserData(key:String)->String {
        //resultをstaticの中に囲んだらエラーは消える
        var result = String()
        //キー値にて指定した箇所に何か入っている場合
        if UserDefaults.standard.object(forKey: key) != nil {
            result = UserDefaults.standard.object(forKey: key) as! String
        }
        //指定した箇所に入っているものを全て変数"result"として返す
        return result
    }
}
