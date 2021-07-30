//
//  UIView+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/29.
//

import UIKit

extension UIView {
    func addSubviews (_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
