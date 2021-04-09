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
    
    var chartArray = [PersonalData]()
    var sendModel = SendModel()
    //getDataProtocolにて最新指定月ユーザー情報を取得したい
    var loadModel = LoadModel()
    
    //pickerView表記用 {$0}は全体を表す
    let years = (2021...2031).map{ $0 }
    let months = (1...12).map{ $0 }
    
    
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
        //ピッカーを隠しておく
        pickerView.isHidden = true
        //LoadModelは何のため？？？
        loadModel.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: dateArray[0] + dateArray[1], day: dateArray[2])
        //タブで画面遷移するのでバックボタンは不必要
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //チャートに反映するための同ユーザーの全データをFSから取得したい
    //今日の日付を取得する
    //dateを取得する
    //dateをパスにしてデータを引っ張ってくる
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //行だがコンポーネントによって違う
        //0だったらyears = (2021...2031).map{ $0 }のカウントを返す
        if component == 0{
            return years.count
        }else if component == 1{
            return months.count
        }else{
            return 0
        }
    }
    
    
    //ピッカービューにおいて年と月を別々に分割して選択できる
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    //ピッカーのタイトルをつける
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return "\(years[row])年"
        }else if component == 1{
            return "\(months[row])月"
        }else{
            return nil
        }
    }
    
    
    //ピッカーが選択された時に呼ばれる箇所
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //選択された値が変数に代入される
        let year = years[pickerView.selectedRow(inComponent: 0)]
        let month = months[pickerView.selectedRow(inComponent: 1)]
        
        //1桁の値の場合は01,02月のように値を渡すための変数（ロード時にパスとして利用）
        var month_1digit = String()
        //1桁の値の場合
        if month < 10 {
            month_1digit = "0" + String(month)
            dateLabel.text = "\(year)年\(month_1digit)月"
            
            loadModel.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: String(year) + month_1digit, day: "")
            //2桁の値の場合
        }else{
            dateLabel.text = "\(year)年\(month)月"
            loadModel.loadMyRecordData(userID: Auth.auth().currentUser!.uid, yearMonth: String(year) + String(month), day: "")
        }
        //選択したタイミングでピッカービューを下げる
        pickerView.isHidden = true
    }
    
    //読み込みが全て完了したら自動でここが呼ばれる（最新のデータ付）
    func getData(dataArray: [PersonalData]) {
        //これを使ってグラフに表していく
        chartArray = dataArray
        //最新データのチャートへの反映
        setUpChart(values: chartArray)
        //1回目→2回目のDHデータの差分(データが登録されていれば)
        if chartArray.count > 0{
            increDecre.text = String(Double(chartArray.last!.dailyHassle)! - Double(chartArray.first!.dailyHassle)!)
            //追加(下にラベルをつける)
            chartView.xAxis.labelPosition = .bottom
            //X軸の縦の線の数
            chartView.xAxis.labelCount = chartArray.count

//            sendModel.sendDailyHassles(userName: GetUserDataModel.getUserData(key: "userModel"), dailyHassles: increDecre.text!)
            //増減の結果をランキング用に送信する
            sendModel.sendResultForRank(userName: GetUserDataModel.getUserData(key: "userName"), dailyHassles: increDecre.text!)
        }
    }
    
    
    //Double型で返す
    func setUpChart(values:[PersonalData]){
        //値をチャートへ反映するメソッド
        var entry = [ChartDataEntry]()
        //（Xは日付、YはDHの数）をその数だけ繰り返す
        for i in 0..<values.count{
            let date = Date(timeIntervalSince1970: values[i].date)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "dd"
            //日付
            let dateString = dateFormatter.string(from: date)
            //(x:Double(dateString)は日付
            //(x:Double(dateString)は日付
            entry.append(ChartDataEntry(x:Double(dateString)!,y: Double(values[i].dailyHassle)!))
        }
        //繰り返しの値が入ったentryを格納する
        let dataSet = LineChartDataSet(entries: entry, label: "My Daily Hassles")
        chartView.data = LineChartData(dataSet: dataSet)
    }
    
    
    //    //反映するために作成
    //    func setUpChart(values:PersonalData){
    //        //値をチャートへ反映するメソッド
    //        var entry = [ChartDataEntry]()
    //        //Xは日付YはDHの数
    //        for i in 0..<values.count{
    //
    //        }
    //    }
    
    
    //チャートのX軸、Y軸を規定
    //出ない場合に疑う場所
    func setUpLineChart(_ chart:LineChartView,data:LineChartData){
        chart.delegate = self
        //項目の表示を行うかどうか
        chart.chartDescription?.enabled = true
        //ドラッグの操作
        chart.dragEnabled = true
        //チャートの拡大表示
        chart.setScaleEnabled(true)
        //メモリの表示
        chart.setViewPortOffsets(left: 15, top: 0, right: 0, bottom: 15)
        //
        chart.legend.enabled = true
        
        //チャートの左の目盛
        chart.leftAxis.enabled = true
        chart.leftAxis.spaceTop = 0.8
        chart.leftAxis.spaceBottom = 0.4
        
        //チャートの右の目盛
        chart.rightAxis.enabled = false
        //目盛線の表示
        chart.xAxis.enabled = true
        //chartのデータの中に取得したdataを入れる
        chart.data = data
        //描画アニメーションを行うか(2秒かけて)
        chart.animate(xAxisDuration: 2)
        
    }
    
    
    @IBAction func toRankVC(_ sender: Any) {
        let rankVC = self.storyboard?.instantiateViewController(identifier: "rankVC") as! RankingViewController
        
        //戻る必要があるのでバックボタンは必要
        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.pushViewController(rankVC, animated: true)
    }
    
    
    @IBAction func pickerShowAction(_ sender: Any) {
        pickerView.isHidden = false
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
