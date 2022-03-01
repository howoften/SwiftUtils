//
//  attributeLabel.swift
//  ISawIt
//
//  Created by liujiang on 2020/12/28.
//  Copyright © 2020 liujiang. All rights reserved.
//

import UIKit
class SUAttributeLabel: UILabel {
    private var attributes = [AnyHashable: Any]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addObserver(self, forKeyPath: #keyPath(SUAttributeLabel.textColor), options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: #keyPath(SUAttributeLabel.font), options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: #keyPath(SUAttributeLabel.textAlignment), options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: #keyPath(SUAttributeLabel.lineBreakMode), options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: #keyPath(SUAttributeLabel.text), options: [.new, .old], context: nil)
    }
    convenience init(text: String?) {
        self.init(frame:CGRect.zero)
        self.text = text
    }
    convenience init(font: UIFont, textColor: UIColor) {
        self.init(frame:CGRect.zero)
        self.text = text
        self.textColor = textColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(SUAttributeLabel.textColor))
        self.removeObserver(self, forKeyPath: #keyPath(SUAttributeLabel.font))
        self.removeObserver(self, forKeyPath: #keyPath(SUAttributeLabel.text))
        self.removeObserver(self, forKeyPath: #keyPath(SUAttributeLabel.textAlignment))
        self.removeObserver(self, forKeyPath: #keyPath(SUAttributeLabel.lineBreakMode))
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else {
            return
        }
        if keyPath == #keyPath(SUAttributeLabel.textColor) {
            self.textColor(change[.newKey] as? UIColor)
        }else if keyPath == #keyPath(SUAttributeLabel.font), let newFont = change[.newKey] as? UIFont {
            self.font(newFont)
        }else if keyPath == #keyPath(SUAttributeLabel.textAlignment), let newAlign = change[.newKey] as? NSTextAlignment {
            self.textAligment(newAlign)
        }else if keyPath == #keyPath(SUAttributeLabel.lineBreakMode), let breakMode = change[.newKey] as? NSLineBreakMode {
            self.lineBreakMode(breakMode)
        }else if keyPath == #keyPath(SUAttributeLabel.text) {
            let text = change[.newKey] as? String
            let old = change[.oldKey] as? String
            if text != old {
                self.text(text)
            }
        }
    }
    
    @discardableResult
    public func fontSize(_ size: CGFloat) -> SUAttributeLabel {
        return self.font(size, nil)
    }
    @discardableResult
    public func fontWeight(_ weight: UIFont.Weight) -> SUAttributeLabel {
        return self.font(nil, weight)
    }
    @discardableResult
    public func font(_ size: CGFloat?, _ weight: UIFont.Weight?) -> SUAttributeLabel {
        var font = attributes[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        if let _size = size {
            font = font.withSize(_size)
        }
        if let _weight = weight {
            font = UIFont.systemFont(ofSize: font.pointSize, weight: _weight)
        }
        self.font(font)
        return self
    }
    @discardableResult
    public func font(_ font: UIFont) -> SUAttributeLabel {
        attributes[NSAttributedString.Key.font] = font
        self.resetTextAttributesStyle()
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor?) -> SUAttributeLabel {
        attributes[NSAttributedString.Key.foregroundColor] = color
        self.resetTextAttributesStyle()
        return self
        
    }
    
    @discardableResult
    public func numberOfLines(_ lines: Int) -> SUAttributeLabel {
        self.numberOfLines = lines
        self.resetTextAttributesStyle()
        return self
        
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor?) -> SUAttributeLabel {
        self.backgroundColor = color
        return self
        
    }
    @discardableResult
    public func textAligment(_ alignment: NSTextAlignment) -> SUAttributeLabel {
        self.textAlignment = alignment
        self.resetTextAttributesStyle()
        return self
    }
    @discardableResult
    public func lineBreakMode(_ breakMode: NSLineBreakMode) -> SUAttributeLabel {
        self.lineBreakMode = breakMode
        self.resetTextAttributesStyle()
        return self
    }
    @discardableResult
    public func lineSpacing(_ spacing: CGFloat) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.lineSpacing] = spacing
        self.resetTextAttributesStyle()
        return self
    }
    @discardableResult
    public func lineHeightMultiple(_ multiHeight: CGFloat) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.lineHeightMultiple] = multiHeight
        self.resetTextAttributesStyle()
        return self
    }
    @discardableResult
    public func minimumLineHeight(_ minHeight: CGFloat) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.minimumLineHeight] = minHeight
        self.resetTextAttributesStyle()
        return self
    }
    @discardableResult
    public func maximumLineHeight(_ maxHeight: CGFloat) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.maximumLineHeight] = maxHeight
        self.resetTextAttributesStyle()
        return self
    }
    @discardableResult
    public func borderColor(_ color: UIColor?) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.borderColor] = color
        if attributes[UILabelLayerAttributeKey.borderWidth] == nil {
            attributes[UILabelLayerAttributeKey.borderWidth] = CGFloat(1.0)
        }
        self.layer.borderColor = color?.cgColor
        if let borderWidth = attributes[UILabelLayerAttributeKey.borderWidth] as? CGFloat {
            self.layer.borderWidth = borderWidth
        }
        return self
    }
    @discardableResult
    public func borderWidth(_ width: CGFloat) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.borderWidth] = width
        self.layer.borderWidth = width
        if let borderColor = (attributes[UILabelLayerAttributeKey.borderColor] as? UIColor)?.cgColor {
            self.layer.borderColor = borderColor
        }
        return self
        
    }
    @discardableResult //描边
    public func strokeColor(_ color: UIColor?) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.strokeColor] = color
        if attributes[UILabelLayerAttributeKey.strokeWidth] == nil {
            attributes[UILabelLayerAttributeKey.strokeWidth] = CGFloat(1.0)
        }
        if self.attributedText?.string.isEmpty != true { //手动触发drawText
            self.attributedText = self.attributedText
        }
        return self
        
    }
    @discardableResult //描边粗细
    public func strokeWidth(_ width: CGFloat) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.strokeWidth] = width
        if self.attributedText?.string.isEmpty != true { //手动触发drawText
            self.attributedText = self.attributedText
        }
        return self
        
    }
    @discardableResult //描边起始形状
    public func lineCap(_ lineCap: CGLineCap) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.lineCap] = lineCap
        if self.attributedText?.string.isEmpty != true { //手动触发drawText
            self.attributedText = self.attributedText
        }
        return self
        
    }
    @discardableResult //描边连接处形状
    public func lineJoin(_ lineJoin: CGLineJoin) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.lineJoin] = lineJoin
        if self.attributedText?.string.isEmpty != true { //手动触发drawText
            self.attributedText = self.attributedText
        }
        return self
        
    }
    @discardableResult //背景色
    public func linearGrandientBackgroundColor(_ gradientColor: UIColor?) -> SUAttributeLabel {
        attributes[UILabelLayerAttributeKey.linearGradientBGColor] = gradientColor
        if self.attributedText?.string.isEmpty != true { //手动触发drawText
            self.attributedText = self.attributedText
        }
        return self
        
    }
    @discardableResult
    public func text(_ text: String?) -> SUAttributeLabel {
        self.text = text
        self.resetTextAttributesStyle()
        return self
        
    }
    private func resetTextAttributesStyle() {
        guard self.text?.isEmpty == false else {
            return
        }
        var labelAttr = attributes
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode
        if let spacing = labelAttr[UILabelLayerAttributeKey.lineSpacing] as? CGFloat {
            paragraphStyle.lineSpacing = spacing
        }
        if let multiHeight = labelAttr[UILabelLayerAttributeKey.lineHeightMultiple] as? CGFloat {
            paragraphStyle.lineHeightMultiple = multiHeight
        }
        if let minHeight = labelAttr[UILabelLayerAttributeKey.minimumLineHeight] as? CGFloat {
            paragraphStyle.minimumLineHeight = minHeight
        }
        if let maxHeight = labelAttr[UILabelLayerAttributeKey.maximumLineHeight] as? CGFloat {
            paragraphStyle.maximumLineHeight = maxHeight
        }
        labelAttr[UILabelLayerAttributeKey.borderColor] = nil
        labelAttr[UILabelLayerAttributeKey.borderWidth] = nil
        labelAttr[UILabelLayerAttributeKey.strokeColor] = nil
        labelAttr[UILabelLayerAttributeKey.strokeWidth] = nil
        labelAttr[UILabelLayerAttributeKey.lineCap] = nil
        labelAttr[UILabelLayerAttributeKey.lineJoin] = nil
        labelAttr[UILabelLayerAttributeKey.linearGradientBGColor] = nil
        labelAttr[UILabelLayerAttributeKey.lineSpacing] = nil
        labelAttr[UILabelLayerAttributeKey.lineHeightMultiple] = nil
        labelAttr[UILabelLayerAttributeKey.minimumLineHeight] = nil
        labelAttr[UILabelLayerAttributeKey.maximumLineHeight] = nil
        
        labelAttr[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        self.attributedText = NSAttributedString(string: self.text!, attributes: labelAttr as? [NSAttributedString.Key:Any])
    }
    override func drawText(in rect: CGRect) {
        let currentAttr = attributes
        guard let context = UIGraphicsGetCurrentContext() else {
            return super.drawText(in: rect)
        }
        if let gradientColor = currentAttr[UILabelLayerAttributeKey.linearGradientBGColor] as? UIColor {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            gradientColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let compoents:[CGFloat] = [0.0/255, 0.0/255, 0.0/255, 0.0,
                                       red, green, blue, alpha,
                                       red, green, blue, alpha,
                                       0.0/255, 0.0/255, 0.0/255, 0.0]
            //没组颜色所在位置（范围0~1)
            let locations:[CGFloat] = [0,0.4,0.6,1.0]
            //生成渐变色（count参数表示渐变个数）
            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                      locations: locations, count: locations.count)!
            
            //渐变开始位置
            let start = CGPoint(x: rect.minX, y: rect.minY)
            //渐变结束位置
            let end = CGPoint(x: rect.maxX, y: rect.minY)
            //绘制渐变
            context.drawLinearGradient(gradient, start: start, end: end,
                                       options: .drawsBeforeStartLocation)
        }
        
        if let strokeWidth = currentAttr[UILabelLayerAttributeKey.strokeWidth] as? CGFloat, strokeWidth > 0 {
            let shadowOffset = self.shadowOffset;
            let textColor = currentAttr[NSAttributedString.Key.foregroundColor] as? UIColor ?? self.textColor
            context.setLineWidth(strokeWidth)
            context.setLineJoin(currentAttr[UILabelLayerAttributeKey.lineJoin] as? CGLineJoin ?? CGLineJoin.bevel)
            context.setLineCap(currentAttr[UILabelLayerAttributeKey.lineCap] as? CGLineCap ?? CGLineCap.square)
            
            context.setTextDrawingMode(.stroke)
            self.textColor = currentAttr[UILabelLayerAttributeKey.strokeColor] as? UIColor ?? UIColor.black;
            super.drawText(in: rect)
            //画内文字
            context.setTextDrawingMode(.fill)
            self.textColor = textColor;
            self.shadowOffset = CGSize.zero;
            super.drawText(in: rect)
            self.shadowOffset = shadowOffset
        } else {
            super.drawText(in: rect)
        }
        
    }
    
    
    
    
    fileprivate struct UILabelLayerAttributeKey: RawRepresentable, Hashable {
        typealias RawValue = Int16
        var rawValue: Int16
        
        init?(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }
        static let borderColor = UILabelLayerAttributeKey(rawValue: 0)
        static let borderWidth = UILabelLayerAttributeKey(rawValue: 1 << 0)
        
        static let strokeColor = UILabelLayerAttributeKey(rawValue: 1 << 1)
        static let strokeWidth = UILabelLayerAttributeKey(rawValue: 1 << 2)
        static let lineCap = UILabelLayerAttributeKey(rawValue: 1 << 3)
        static let lineJoin = UILabelLayerAttributeKey(rawValue: 1 << 4)
        
        static let linearGradientBGColor = UILabelLayerAttributeKey(rawValue: 1 << 5)
        
        static let lineSpacing = UILabelLayerAttributeKey(rawValue: 1 << 6)
        static let lineHeightMultiple = UILabelLayerAttributeKey(rawValue: 1 << 7)
        static let minimumLineHeight = UILabelLayerAttributeKey(rawValue: 1 << 8)
        static let maximumLineHeight = UILabelLayerAttributeKey(rawValue: 1 << 9)
        
    }
    
}
