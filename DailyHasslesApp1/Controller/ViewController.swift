//
//  ViewController.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/02.
//

import UIKit
import Firebase
import FirebaseAuth
//ローディングぐるぐるのやつ
//import NVActivityIndicatorView

class ViewController: UIViewController {
    
//    //Twitterログイン用
//    var provider:OAuthProvider?
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
//        provider?.customParameters = ["lang":"ja"]
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        //空判定
        if userNameTextField.text?.isEmpty != true {
            //FB匿名登録
            Auth.auth().signInAnonymously { (result, error) in
                //エラー判定
                if error != nil {
                    print(error.debugDescription)
                }else{
                    //アプリ内保存
                    UserDefaults.standard.setValue(self.userNameTextField.text, forKey: "userName")
                    //"TabBarController"へ画面遷移
                    let tabBC = self.storyboard?.instantiateViewController(identifier: "tabBC") as! TabBarController
                    self.navigationController?.pushViewController(tabBC, animated: true)
                }
            }
        }
    }
    
    
//    @IBAction func twitterLoginAction(_ sender: Any) {
//        //providerから認証を受ける
//        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
//        provider?.customParameters = ["force_login":"true"]
//        //値を受け取る（credential）
//        provider?.getCredentialWith(nil, completion: { (credential, error) in
//
//            //ぐるぐるモーションの設定
//            let activityView = NVActivityIndicatorView(frame: self.view.bounds, type: .ballDoubleBounce, color: .magenta, padding: .none)
//            //画面に表示
//            self.view.addSubview(activityView)
//            //モーション開始
//            activityView.startAnimating()
//            //->これが終わってからログインの処理が始まる
//
//            //Firebaseにてログイン処理
//            Auth.auth().signIn(with: credential!) { (result, error) in
//                if error != nil{
//                    return
//                }
//                //モーション終了
//                activityView.stopAnimating()
//
//
//                //Twitterのユーザーネームをアプリ内保存
//                UserDefaults.standard.setValue(result?.user.displayName, forKey: "userName")
//
//                //"TabBarController"へ画面遷移
//                let tabBC = self.storyboard?.instantiateViewController(identifier: "tabBC") as! TabBarController
//                self.navigationController?.pushViewController(tabBC, animated: true)
//            }
//        })
//    }
}

