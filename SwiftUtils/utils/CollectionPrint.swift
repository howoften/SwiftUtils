//
//  jsonserialize.swift
//  ISawIt
//
//  Created by liujiang on 2020/10/13.
//  Copyright © 2020 liujiang. All rights reserved.
//

import Foundation
extension Dictionary {
    func jsonString() -> String {
        var json: String = "{"
        let allKeys = self.keys.sorted { "\($0)" < "\($1)" }
        for key in allKeys {
            let v = self[key]
            guard let value = v else {
                continue
            }
            json = json + "\"\(key)\":"
            if let value1 = value as? [AnyHashable:Any] {
                json = json + value1.jsonString()
            }else if let value1 = value as? [Any] {
                json = json + value1.jsonString()
            }else if let value1 = value as? Bool {
                json = json + (value1 ? "true" : "false")
            }else if !(value is String), self.isNumberString("\(value)") {
                json = json + "\(value)"
            }else {
                json = json + "\"\(value)\""
            }
            json = json + ","
        }
        
        json = json.replacingOccurrences(of: "\\", with: "\\\\")
        json = json.replacingOccurrences(of: "/", with: "\\/")
        json = json.replacingOccurrences(of: "\n", with: "\\n")
        json = json.replacingOccurrences(of: "\t", with: "\\t")
        json = json.replacingOccurrences(of: "\r", with: "\\r")
        json = String(json[json.startIndex..<json.index(before: json.endIndex)])
        json = json + "}"
        return json
    }
    
    
    private func isNumberString(_ obj: String) -> Bool {
        guard obj.count > 0 else {
            return false
        }
        let regex = "^[+-]{0,}\\d*[.]{0,}\\d+$"
        return (obj.range(of: regex, options: .regularExpression, range:Range(uncheckedBounds: (lower: obj.startIndex, upper: obj.endIndex)), locale: nil) != nil)
    }
    
    func prettyPrint() {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        if let jsonData = data {
            let jsonStr = String(data:jsonData, encoding: .utf8)
            guard let unwrapStr = jsonStr else {
                print("[Not support json object for print: \(self)], use '__prettyPrint()' instead")
                return
            }
            var trimedStr = unwrapStr.replacingOccurrences(of: "\t", with: "")
            trimedStr = unwrapStr.replacingOccurrences(of: "\r", with: "")
            let arr = trimedStr.components(separatedBy: "\n")
            arr.forEach({
                print($0)
            })
            return
        }
        print("[Not support json object for print: \(self)], use '__prettyPrint()' instead")
    }
    fileprivate func __prettyPrint(newlineEnd: Bool, indent: String, subIndent: String, trailingIndent: String) {
        print(indent, "{")
        let allKeys = self.keys.sorted { "\($0)" < "\($1)" }
        for key in allKeys {
            let v = self[key]
            guard let value = v else {
                continue
            }
            print(subIndent, "\"\(key)\":", terminator: "")
            if let value1 = value as? [AnyHashable:Any] {
                value1.__prettyPrint(newlineEnd: false, indent:"", subIndent: subIndent + "\t", trailingIndent: subIndent)
            }else if let value1 = value as? [Any] {
                value1.__prettyPrint(newlineEnd: false, indent:"", subIndent: subIndent + "\t", trailingIndent: subIndent)
            }else if let value1 = value as? Bool {
                print(value1 ? "true" : "false", terminator: "")
            }else if !(value is String), self.isNumberString("\(value)") {
                print("\(value)", terminator: "")
            }else {
                print("\"\(value)\"".replacingOccurrences(of: "/", with: "\\/").replacingOccurrences(of: "\\", with: "\\\\"), terminator: "")
            }
            if key != allKeys.last {
                print(",")
            }
        }
        print("")
        newlineEnd ? print(trailingIndent, "}") : print(trailingIndent, "}", terminator: "")
    }
    func __prettyPrint() {
        self.__prettyPrint(newlineEnd: true, indent: "", subIndent: "\t", trailingIndent: "")
    }
}

extension Array {
    func jsonString() -> String {
        let optArray = self as [Any?]
        var json: String = "["
        for (i, v) in optArray.enumerated() {
            guard let value = v else {
                json = json + "null"
                if i != self.count-1 {
                    json = json + ","
                }
                continue
            }
            if let value1 = value as? [AnyHashable:Any] {
                json = json + value1.jsonString()
            }else if let value1 = value as? [Any] {
                json = json + value1.jsonString()
            }else if let value1 = value as? Bool {
                json = json + (value1 ? "true" : "false")
            }else if !(value is String), self.isNumberString("\(value)") {
                json = json + "\(value)"
            }else {
                json = json + "\"\(value)\""
            }
            if i != self.count-1 {
                json = json + ","
            }
        }
        json = json.replacingOccurrences(of: "\\", with: "\\\\")
        json = json.replacingOccurrences(of: "/", with: "\\/")
        json = json.replacingOccurrences(of: "\n", with: "\\n")
        json = json.replacingOccurrences(of: "\t", with: "\\t")
        json = json.replacingOccurrences(of: "\r", with: "\\r")
        json = json + "]"
        return json
    }
    
    
    private func isNumberString(_ obj: String) -> Bool {
        guard obj.count > 0 else {
            return false
        }
        let regex = "^[+-]{0,}\\d*[.]{0,}\\d+$"
        return (obj.range(of: regex, options: .regularExpression, range:Range(uncheckedBounds: (lower: obj.startIndex, upper: obj.endIndex)), locale: nil) != nil)
    }
    
    func prettyPrint() {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        if let jsonData = data {
            let jsonStr = String(data:jsonData, encoding: .utf8)
            guard let unwrapStr = jsonStr else {
                print("[Not support json object for print: \(self)], use '__prettyPrint()' instead")
                return
            }
            var trimedStr = unwrapStr.replacingOccurrences(of: "\t", with: "")
            trimedStr = unwrapStr.replacingOccurrences(of: "\r", with: "")
            let arr = trimedStr.components(separatedBy: "\n")
            arr.forEach({
                print($0)
            })
            return
        }
        print("[Not support json object for print: \(self)], use '__prettyPrint()' instead")
    }
    
    fileprivate func __prettyPrint(newlineEnd: Bool, indent: String, subIndent: String, trailingIndent: String) {
        let optArray = self as [Any?]
        print(indent, "[")
        for (i, v) in optArray.enumerated() {
            guard let value = v else {
                print(subIndent, "null", terminator: "")
                if i != self.count-1 {
                    print(",")
                }
                continue
            }
            if let value1 = value as? [AnyHashable:Any] {
                value1.__prettyPrint(newlineEnd: false, indent: subIndent, subIndent: subIndent + "\t", trailingIndent: subIndent)
            }else if let value1 = value as? [Any] {
                value1.__prettyPrint(newlineEnd: false, indent: subIndent, subIndent: subIndent + "\t", trailingIndent: subIndent)
            }else if let value1 = value as? Bool {
                print(subIndent, value1 ? "true" : "false", terminator: "")
            }else if !(value is String), self.isNumberString("\(value)") {
                print(subIndent, "\(value)", terminator: "")
            }else {
                print(subIndent,"\"\(value)\"".replacingOccurrences(of: "/", with: "\\/").replacingOccurrences(of: "\\", with: "\\\\"), terminator: "")
            }
            if i != self.count-1 {
                print(",")
            }
        }
        print("")
        newlineEnd ? print(trailingIndent, "]") : print(trailingIndent, "]", terminator: "")
    }
    func __prettyPrint() {
        self.__prettyPrint(newlineEnd: true, indent: "", subIndent: "\t", trailingIndent: "")
    }
}
extension Optional {
     func prettyPrint() {
        if let array = self as? Array<Any> {
            array.__prettyPrint()
        }else if let dic = self as? [AnyHashable:Any] {
            dic.__prettyPrint()
        }else if let other = self {
            print("Pretty Print Fail, not support obj: \(other)")
        }
    }
}
extension NSArray {
    @objc func prettyPrint() {
        if let array = self as? Array<Any> {
            array.prettyPrint()
        }else {
            print("Pretty Print Fail, not support obj: \(self)")
        }
    }
}
extension NSDictionary {
    @objc func prettyPrint() {
        if let dic = self as? [AnyHashable:Any] {
            dic.prettyPrint()
        }else {
            print("Pretty Print Fail, not support obj: \(self)")
        }
    }
}

extension String {
    
    func jsonObject() -> Any? {
        let json = try? JSONSerialization.jsonObject(with: self.data(using: .utf8) ?? Data(), options: .fragmentsAllowed)
        return json
    }
}
