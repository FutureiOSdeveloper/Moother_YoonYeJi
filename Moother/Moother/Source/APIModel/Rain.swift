//
//  Rain.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        the1H = (try? value.decode(Double.self, forKey: .the1H)) ?? 0
    }
}
