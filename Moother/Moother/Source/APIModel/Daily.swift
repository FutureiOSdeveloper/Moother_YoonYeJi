//
//  Daily.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation

struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        dt = (try? value.decode(Int.self, forKey: .dt)) ?? 0
        sunrise = (try? value.decode(Int.self, forKey: .sunrise)) ?? 0
        sunset = (try? value.decode(Int.self, forKey: .sunset)) ?? 0
        moonrise = (try? value.decode(Int.self, forKey: .moonrise)) ?? 0
        moonset = (try? value.decode(Int.self, forKey: .moonset)) ?? 0
        moonPhase = (try? value.decode(Double.self, forKey: .moonPhase)) ?? 0
        temp = (try value.decode(Temp.self, forKey: .temp))
        pressure = (try? value.decode(Int.self, forKey: .pressure)) ?? 0
        humidity = (try? value.decode(Int.self, forKey: .humidity)) ?? 0
        dewPoint = (try? value.decode(Double.self, forKey: .dewPoint)) ?? 0
        uvi = (try? value.decode(Double.self, forKey: .uvi)) ?? 0
        clouds = (try? value.decode(Int.self, forKey: .clouds)) ?? 0
        windSpeed = (try? value.decode(Double.self, forKey: .windSpeed)) ?? 0
        windDeg = (try? value.decode(Int.self, forKey: .windDeg)) ?? 0
        windGust = (try? value.decode(Double.self, forKey: .windGust)) ?? 0
        weather = (try value.decode([Weather].self, forKey: .weather))
        pop = (try? value.decode(Double.self, forKey: .pop)) ?? 0
        feelsLike = (try value.decode(FeelsLike.self, forKey: .feelsLike))
        rain = (try? value.decode(Double.self, forKey: .rain)) ?? 0
    }
}
