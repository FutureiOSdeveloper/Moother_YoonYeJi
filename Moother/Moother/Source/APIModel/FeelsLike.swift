//
//  FeelsLike.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

struct FeelsLike: Codable {
    let day, night, eve, morn: Double
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        day = (try? value.decode(Double.self, forKey: .day)) ?? 0
        night = (try? value.decode(Double.self, forKey: .night)) ?? 0
        eve = (try? value.decode(Double.self, forKey: .eve)) ?? 0
        morn = (try? value.decode(Double.self, forKey: .morn)) ?? 0
    }
}
