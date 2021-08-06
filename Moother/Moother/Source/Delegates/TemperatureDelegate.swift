//
//  TemperatureDelegate.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/06.
//

import Foundation

enum temperature {
    case celsius
    case fahrenheit
}

protocol TemperatureDelegate {
    func switchButtonDidSelected(unit temperature: temperature)
}

