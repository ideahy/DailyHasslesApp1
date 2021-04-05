//
//  RecordViewController.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/03.
//

import UIKit

class RecordViewController: UIViewController {
    
    //FSに送信するものを集約したモデルにアクセス可能
    var sendModel = SendModel()
    var alertSystem = AlertSystem()
    
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var inputDHTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //今日の日付を表示する("false"->"/"無)
        todayLabel.text = GetDateModel.getTodayDate(slash: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //タブで画面遷移するのでバックボタンは不必要
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //キーボード外をタッチしたら
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる
        inputDHTextField.resignFirstResponder()
    }
    
    
    @IBAction func recordAction(_ sender: Any) {
        //FSの中にuserName,DHの数,日付を格納する
        //（SendModel）FSに送信するものを集約する
        sendModel.sendDailyHassles(userName: GetUserDataModel.getUserData(key: "userName"), dailyHassles: inputDHTextField.text!)
        //アラートを表示(保存されました！)
        alertSystem.showAlert(title: "title:保存！", message: "message:", buttonTitle: "buttonTitle:OK ", viewController: self)
        //保存されたことを確認したのちのアラートにしたいが、、、のちに処理
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
