//
//  SettingViewController.swift
//  DailyHasslesApp1
//
//  Created by 山本英明 on 2021/04/07.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signoutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out : %@", signOutError)
        }
        
        //"firstVC"へ画面遷移
        let firstVC = self.storyboard?.instantiateViewController(identifier: "firstVC") as! ViewController
        self.navigationController?.pushViewController(firstVC, animated: true)
    }
}
