//
//  ReusableCell+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/21.
//

import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
