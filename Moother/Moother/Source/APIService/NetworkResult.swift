//
//  NetworkResult.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
