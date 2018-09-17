//
//  SideNavigationTableViewCell.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class SideNavigationTableViewCell: UITableViewCell {
    
    var titleText:String?{
        didSet{
            updateTitle(text: titleText)
            self.setNeedsLayout()
        }
    }
    
    let attrSelected: [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 24),
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleThick.rawValue,
        NSAttributedStringKey.foregroundColor : UIColor(red: 227/255, green: 114/255, blue: 39/255, alpha: 1.0)
    ]
    let attrUnselected: [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 24),
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleNone.rawValue,
        NSAttributedStringKey.foregroundColor : UIColor.black
    ]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    convenience init(){
        self.init(style: .default, reuseIdentifier: "SideNavigationCell")
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView(){
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .clear
        updateTitle(text: self.titleText)
    }
    
    func updateTitle(text:String?){
        if let textString = text{
            let textRange = NSMakeRange(0, textString.count)
            let attributedText = NSMutableAttributedString(string: textString)
            if self.isSelected{
                attributedText.addAttributes(attrSelected, range: textRange)
            } else{
                attributedText.addAttributes(attrUnselected, range: textRange)
            }
            self.textLabel?.attributedText = attributedText
        } else{
            self.textLabel?.text = ""
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textLabel = self.textLabel{
            textLabel.sizeToFit()
            textLabel.frame.origin = CGPoint(x: 40, y: self.bounds.size.height*0.5 - textLabel.frame.size.height*0.5)
        }
    }
    
    
}
