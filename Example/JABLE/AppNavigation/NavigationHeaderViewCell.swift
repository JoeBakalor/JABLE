//
//  NavigationHeaderViewCell.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class NavigationHeaderViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    convenience init(){
        self.init(style: .default, reuseIdentifier: "UsernameCell")
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
        if selected{
            self.textLabel?.textColor = .black
        } else{
            self.textLabel?.textColor = .yellow
        }
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let pad:CGFloat = 8
        self.imageView?.frame = CGRect(x: 30 + pad, y: pad, width: self.frame.size.height-pad*2, height: self.frame.size.height-pad*2)
        self.textLabel?.sizeToFit()
        let left:CGFloat = self.imageView?.frame.size.width ?? 0
        self.textLabel?.frame.origin = CGPoint(x: left + pad * 2, y: self.bounds.size.height - pad - (self.textLabel?.frame.size.height ?? 0) - pad)
    }
    
}
