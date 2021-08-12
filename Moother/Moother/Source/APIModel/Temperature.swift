//
//  Temperature.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        day = (try? value.decode(Double.self, forKey: .day)) ?? 0
        min = (try? value.decode(Double.self, forKey: .min)) ?? 0
        max = (try? value.decode(Double.self, forKey: .max)) ?? 0
        night = (try? value.decode(Double.self, forKey: .night)) ?? 0
        eve = (try? value.decode(Double.self, forKey: .eve)) ?? 0
        morn = (try? value.decode(Double.self, forKey: .morn)) ?? 0
    }
}
