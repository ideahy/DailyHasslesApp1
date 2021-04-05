//
//  AlertSystem.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/05.
//

import Foundation
import EMAlertController

class AlertSystem {
    
    //引数を処理してコントローラに表示したい
    //buttonTitle="yes","no"とか
    //viewController=表示するのはどのコントローラか
    func showAlert(title:String,message:String,buttonTitle:String,viewController:UIViewController){

        //title,messageは引数を利用
        let alert = EMAlertController(title: title, message: message)
        //titleはキャンセル用のものを用意
        let close = EMAlertAction(title: buttonTitle, style: .cancel)
        alert.cornerRadius = 10.0
        alert.iconImage = UIImage(named: "ok")
        //キャンセル用のアクションをアラートに追加
        alert.addAction(close)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
