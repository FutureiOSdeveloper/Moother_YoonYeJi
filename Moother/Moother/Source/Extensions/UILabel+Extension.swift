//
//  UILabel+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/08.
//

import UIKit

extension UILabel {
    
    func addHighlightingText(highlightText: String) {
        let attributtedString = NSMutableAttributedString(string: text!)
        attributtedString.addAttribute(.foregroundColor, value: UIColor.white, range: (text! as NSString).range(of: highlightText))
        
        attributedText = attributtedString
    }
    
}
