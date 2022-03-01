//
//  ViewController.swift
//  SwiftUtils
//
//  Created by liujiang on 2022/3/1.
//

import UIKit

class ViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.backgroundColor = .purple
        view.addSubview(label)
        
        
        let label1 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .red)
        label1.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label1.text = "Hello World!"
        label1.backgroundColor = .purple
        view.addSubview(label1)
        
        let label2 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .yellow).numberOfLines(0).lineSpacing(4)
        label2.frame = CGRect(x: 80, y: accumY, width: 200, height: 50)
        label2.text = "Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!"
        label2.backgroundColor = .purple
        view.addSubview(label2)
        _accumY += 20
        
        let label3 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .black)
        label3.borderColor(.green)
        label3.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label3.text = "Hello World!Hello World!Hello World!Hello"
        view.addSubview(label3)
        
        
        let label5 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .lightGray).linearGrandientBackgroundColor(.black)
        label5.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label5.text = "linearGrandientBackgroundColor"
        view.addSubview(label5)
        
        self.view = view
        
        
        let dic = ["key1":1,
                   "key2":"name",
        //           "key3":nil,
                   "key4":NSObject(),
                   "key5":[1, "2", "zhangsans", NSNull()],
                   "key6":["1":1, "2":[2, 3], "3":["key":100]]
        ] as [String:Any]

//        dic.prettyPrint()
        dic.__prettyPrint()
        let jsonStr = dic.jsonString()
        print(jsonStr)
        
        let numberOfString = Int(optAny: "10.253")
        //weak reference array
        let obj1 = NSObject()
        let obj2 = NSObject()
        //let weakArr = WeakArray<NSObject>([obj1, obj2])
        let weakArr = WeakArray<NSObject>()
        weakArr.append(obj1)
        weakArr.append(obj2)
        print(weakArr)
        let at = (obj2, obj1)
        print(at)
    }
    
    var _accumY:CGFloat = 0
    var accumY: CGFloat {
        _accumY += 40
        return _accumY
    }
}

