//
//  Util.swift
//  CrazyIdiom
//
//  Created by liujiang on 2019/12/24.
//  Copyright © 2019 xox. All rights reserved.
//
import UIKit
//MARK: downcast Any to expect type
extension Int {
    init?(optAny: Any?) {
        if let _value = optAny as? NSNumber {
            self.init(_value.intValue)
            return
        }
        guard let stringValue = String(onlyString: optAny) else {
            return nil
        }
        self.init(stringValue)
    }
}

extension CGFloat {
    init?(optAny: Any?) {
        if let _value = optAny as? NSNumber {
            self.init(_value.floatValue)
            return
        }
        guard let stringValue = String(optAny: optAny) else {
            return nil
        }
        let regex = "^[+-]*\\d*(\\.)*\\d+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        guard predicate.evaluate(with: stringValue) else {
            return nil
        }
        self.init(Float(stringValue) ?? 0)
    }
}
extension Float {
    init?(optAny: Any?) {
        if let _value = optAny as? NSNumber {
            self.init(_value.floatValue)
            return
        }
        guard let stringValue = String(onlyString: optAny) else {
            return nil
        }
        self.init(stringValue)
    }
}

extension Double {
    init?(optAny: Any?) {
        if let _value = optAny as? NSNumber {
            self.init(_value.doubleValue)
            return
        }
        guard let stringValue = String(onlyString: optAny) else {
            return nil
        }
        self.init(stringValue)
        
    }
}
extension Bool {
    init?(optAny: Any?) {
        if let rawStr = String(onlyString: optAny), Float(optAny: optAny) == nil {
            if rawStr.lowercased() == "true" {
                self.init(true)
                return
            }else if rawStr.lowercased() == "false" {
                self.init(false)
                return
            }
            return nil
        }
        if let _value = Float(optAny: optAny) {
            self.init(_value != 0)
            return
        }
        return nil
        
    }
}
extension String {
    init?(optAny: Any?) {
        if let rawValue = optAny {
            self.init("\(rawValue)")
            return
        }
        return nil
        
    }
    
    init?(onlyString: Any?) {
        if let rawValue = onlyString as? String {
            self.init(rawValue)
            return
        }
        if let rawValue = onlyString as? Substring {
            self.init(rawValue)
            return
        }
        if let rawValue = onlyString as? Character {
            self.init(rawValue)
            return
        }
        if let rawValue = onlyString as? NSString {
            self.init(rawValue)
            return
        }
        return nil
        
    }
}
let anyEqualTo:((Any?, Any?) -> Bool) = {
    guard $0 != nil else {
        return $1 == nil ? true : false
    }
    // as string
    if "\($0!)" == "\($1 ?? "\(NSNotFound)")" {
        return true
    }
    if Float(optAny: $0) == Float(optAny: $1), Float(optAny: $0) != nil {
        return true
    }
    if Bool(optAny: $0) == Bool(optAny: $1), Bool(optAny: $1) != nil {
        return true
    }
    if let lhs = $0 as? [AnyHashable:Any] {
        if let rhs = $1 as? [AnyHashable:Any] {
            return lhs.jsonString() == rhs.jsonString()
        }
        return false
    }
    if let lhs = $0 as? [Any] {
        if let rhs = $1 as? [Any] {
            return lhs.jsonString() == rhs.jsonString()
        }
        return false
    }
    
    return false
    
}
//(10...20).random    // 16
//(0...1).random(10)  // [0, 1, 0, 0, 1, 1, 1, 1, 1, 0]
extension Range where Bound: FixedWidthInteger {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }
}
extension ClosedRange where Bound: FixedWidthInteger  {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }
}
extension Optional {
    /// Returns true if the optional is none.
    /// (如果可选值为空则返回true).
    var isNone: Bool {
        switch self {
        case .none: return true
        default: return false }
    }
    /// Returns true if the optional is none or empty.
    /// (如果可选值为空则返回true).
    var isNoneOrEmpty: Bool {
        switch self {
        case .none: return true
        default:
            if let strValue = self as? String {
                return strValue.isEmpty
            }else if let arrayValue = self as? [Any] {
                return arrayValue.isEmpty
            }else if let dicValue = self as? [AnyHashable:Any] {
                return dicValue.isEmpty
            }else if let setValue = self as? Set<AnyHashable> {
                return setValue.isEmpty
            }
            return false
        }
    }
    
    /// Returns true if the optional is not empty.
    /// (如果可选值不为空则返回true).
    var isSome: Bool {
        switch self {
        case .some(_): return true
        default: return false }
    }
}
extension Optional {
    /// Return the value of the Optional or the `default` parameter
    /// (若可选值为 nil, 则返回 default).
    /// - param: The value to return if the optional is empty
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }

    /// Returns the unwrapped value of the optional *or*
    /// the result of an expression `else`
    /// I.e. optional.or(else: print("Arrr"))
    /// (若可选值为 nil, 则执行 else 获取返回内容).
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    /// Returns the unwrapped value of the optional *or*
    /// the result of calling the closure `else`
    /// I.e. optional.or(else: {
    /// ... do a lot of stuff
    /// })
    /// (若可选值为 nil, 则执行 else 获取返回内容).
    func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }

    /// Returns the unwrapped contents of the optional if it is not empty
    /// If it is empty, throws exception `throw`
    /// (若可选值为 nil, 则返回一个Error).
    func or(throw exception: Error) throws -> Wrapped {
        guard let unwrapped = self else { throw exception }
        return unwrapped
    }
}

extension Optional where Wrapped == Error {
    /// Only perform `else` if the optional has a non-empty error value
    //// (Error 可选类型有值则返回 error 值, 否则执行 else).
    func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}
