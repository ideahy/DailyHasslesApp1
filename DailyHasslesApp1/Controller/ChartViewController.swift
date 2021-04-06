//
//  ChartViewController.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/05.
//

import UIKit
import Charts
import FirebaseAuth

//LoadModel内で取得した最新指定月ユーザーデータはGetDataProtocolが持っている

class ChartViewController: UIViewController,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,GetDataProtocol {

    
    @IBOutlet weak var increDecre: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //getDataProtocolにて最新指定月ユーザー情報を取得したい
    var loadModel = LoadModel()
    
    //pickerView表記用 {$0}は全体を表す
    let years = (2021...2031).map{ $0 }
    let months = (2021...12).map{ $0 }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pickerViewを使うときはデリゲートが必要
        pickerView.delegate = self
        pickerView.dataSource = self
        //チャート（グラフ）の背景色
        chartView.backgroundColor = .white
        //ちょっと透けさせる
        chartView.alpha = 0.9
        //getDataProtocolにて最新指定月ユーザー情報を取得したい
        loadModel.getDataProtocol = self
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //現在時刻→年月を確認→その月のデータを全て取得する
        let date = GetDateModel.getTodayDate(slash: true)
        let dateArray = date.components(separatedBy: "/")
        //LoadModelは何のため？？？
        loadModel.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: dateArray[0] + dateArray[1], day: dateArray[2])
    }
    
    
    //チャートに反映するための同ユーザーの全データをFSから取得したい
    //今日の日付を取得する
    //dateを取得する
    //dateをパスにしてデータを引っ張ってくる
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    

    //読み込みが全て完了したら自動でここが呼ばれる（最新のデータ付）
    func getData(dataArray: [PersonalData]) {
        <#code#>
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
