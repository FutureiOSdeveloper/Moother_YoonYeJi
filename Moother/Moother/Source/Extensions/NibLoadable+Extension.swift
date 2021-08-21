//
//  NibLoadable+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/21.
//

import UIKit

protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
