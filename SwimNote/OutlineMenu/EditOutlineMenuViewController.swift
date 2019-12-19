//
//  EditOutlineMenuViewController.swift
//  SwimNote
//
//  Created by 雨宮佳音 on 2019/12/11.
//  Copyright © 2019 kanon. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import FirebaseDatabase

class EditOutlineMenuViewController: FormViewController {
    
    var selectedOutlineMenu: OutlineMenu!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        form +++ Section("")
            <<< ButtonRow("この内容に変更") { (row: ButtonRow) in
                row.title = row.tag
                }
                .onCellSelection({ (cell, row) in
                    //更新するコードを書く
                    self.updateOutlineMenu()
                    let alertController = UIAlertController(title: "変更完了！", message:"入力された内容に変更しました。", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                })
        
        form +++ Section("概要")
            <<< DateRow("date") {
                $0.title = "日付"
            }
            <<< TimeInlineRow("startTime") {
                $0.title = "開始時刻"
            }
            <<< TimeInlineRow("endTime") {
                $0.title = "終了時刻"
            }
            <<< TextRow("place") {
                $0.title = "場所"
                $0.placeholder = "プールの名前を入力"
                $0.value = selectedOutlineMenu.place
            }
            <<< SegmentedRow<String>("poolType") {
                $0.options = ["短水路", "長水路"]
                $0.title = "プールの長さ                        "
                $0.value = selectedOutlineMenu.place
                }.onChange{ row in
                    let userDefault = UserDefaults.standard
                    userDefault.setValue(row.value, forKey: "")
            }
            <<< TextRow("length") {
                $0.title = "合計距離"
                $0.placeholder = "合計距離を入力"
                $0.value = selectedOutlineMenu.length
        }
        
        form +++ ButtonRow() {
            $0.title = "メニューの追加"
            $0.onCellSelection { cell, row in
                print("tapped")
                self.performSegue(withIdentifier: "toTraining", sender: nil)
            }
        }

    }
    
    func updateOutlineMenu() {
        let formValues = self.form.values()
        let date = formValues["date"] as! String
        let startTime = formValues["startTime"] as! String
        let endTime = formValues["endTime"] as! String
        let place = formValues["place"] as? String
        let poolType = formValues["poolType"] as? String
        let length = formValues["length"] as? Date
        
        
        let menu = ["date": date.description,
                    "startTime": startTime,
                    "endTime": endTime,
                    "place": place,
                    "poolType": poolType,
                    "length": length] as [String : Any]
        ref.child("competition/\(selectedOutlineMenu.id)").updateChildValues(menu)
    }
    
    func removeOutlineMenu() {
        let formValues = self.form.values()
        let date = formValues["date"] as! String
        let startTime = formValues["startTime"] as! String
        let endTime = formValues["endTime"] as! String
        let place = formValues["place"] as? String
        let poolType = formValues["poolType"] as? String
        let length = formValues["length"] as? Date
        
        let menu = ["date": date.description,
                    "startTime": startTime,
                    "endTime": endTime,
                    "place": place,
                    "poolType": poolType,
                    "length": length] as [String : Any]
        
        self.ref.child("competition/\(selectedOutlineMenu.id)").childByAutoId().removeValue()
    }
    
    
    
    @IBAction func remove(){
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.removeOutlineMenu()
            self.navigationController?.popViewController(animated: true)
            print("OK")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
