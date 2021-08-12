//
//  WeatherReponse.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        lat = (try? value.decode(Double.self, forKey: .lat)) ?? 0
        lon = (try? value.decode(Double.self, forKey: .lon)) ?? 0
        timezone = (try? value.decode(String.self, forKey: .timezone)) ?? ""
        timezoneOffset = (try? value.decode(Int.self, forKey: .timezoneOffset)) ?? 0
        current = (try value.decode(Current.self, forKey: .current))
        hourly = (try value.decode([Current].self, forKey: .hourly))
        daily = (try value.decode([Daily].self, forKey: .daily))
    }
}
