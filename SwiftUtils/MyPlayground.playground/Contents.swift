//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import SwiftUtils

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.backgroundColor = .tintColor
        view.addSubview(label)
        
        
        let label1 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .red)
        label1.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label1.text = "Hello World!"
        label1.backgroundColor = .tintColor
        view.addSubview(label1)
        
        let label2 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .yellow).numberOfLines(0).lineSpacing(4)
        label2.frame = CGRect(x: 80, y: accumY, width: 200, height: 50)
        label2.text = "Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!"
        label2.backgroundColor = .tintColor
        view.addSubview(label2)
        _accumY += 20
        
        let label3 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .black)
        label3.borderColor(.green).borderWidth(2)
        label3.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label3.text = "Hello World!Hello World!Hello World!Hello"
        view.addSubview(label3)
        
        let label4 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .black).strokeColor(.orange).strokeWidth(2)
        label4.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label4.text = "Hello World!Hello World!Hello World!Hello"
        view.addSubview(label4)
        
        let label5 = SUAttributeLabel(font: UIFont.systemFont(ofSize: 13, weight: .medium), textColor: .white).linearGrandientBackgroundColor(.black)
        label5.frame = CGRect(x: 80, y: accumY, width: 200, height: 20)
        label5.text = "Hello World!Hello World!Hello World!Hello"
        view.addSubview(label5)
        
        
        self.view = view
    }
    
    var _accumY:CGFloat = -20
    var accumY: CGFloat {
        _accumY += 40
        return _accumY
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


//json serialize, json print
let dic = ["key1":1,
           "key2":"name",
//           "key3":nil,
           "key4":NSObject(),
           "key5":[1, "2", "zhangsans", NSNull()],
           "key6":["1":1, "2":[2, 3], "3":["key":100]]
] as [String:Any]

let standarJSON = ["key":1, "key2":0.3, "key3":true, "key4":"str"] as [String:Any]
standarJSON.prettyPrint()
dic.__prettyPrint()
let jsonStr = dic.jsonString()
print("jsonString without whitespace, newline, tabe:", jsonStr)

//compare any variable
let int_bool_equal = anyEqualTo(0, true)
let string_bool_equal = anyEqualTo("5", true)
let nil_bool_equal = anyEqualTo(nil, true)
let nil_nil_equal = anyEqualTo(nil, nil)
let array_tuple_equal = anyEqualTo([1, 2], (1, 2))

let numberOfStr = Int(optAny: "aaaa")
let numberOfString = Int(optAny: "10.253")
let numberOfStringInteger = Int(optAny: "10")
let boolOfString = Bool(optAny: "true")
let boolOfInteger = Bool(optAny: 100)


//weak reference array
let obj1 = NSObject()
let obj2 = NSObject()
let weakArr = WeakArray<NSObject>([obj1, obj2])
weakArr.remove(obj1)
//let weakArr = WeakArray<NSObject>()
//weakArr.append(obj1)
//weakArr.append(obj2)
print(weakArr)


//array extension
var data = [
    ["id":1],
    ["id":2],
    ["id":1],
    ["id":3],
    ["id":3],
    ["id":4],
]
//数组剔重
data.filterDuplicates({ $0["id"]})
print(data)

var arrayInArray = [["1", "2"], [1, 2], [NSObject(), NSObject()]]
arrayInArray.enumerateNested { obj, stop in
    print(obj)
}


let allInteger: Bool = arrayInArray.reduceNested(true, { $0 && $1 is Int })
print(allInteger)
let allString: Bool = ["1", "2", "3"].reduceNested(true, { $0 && $1 is String })
print(allString)
