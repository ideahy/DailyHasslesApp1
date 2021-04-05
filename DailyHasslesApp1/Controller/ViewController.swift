//
//  ViewController.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/02.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
}

