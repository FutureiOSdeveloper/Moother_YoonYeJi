//
//  OneCallModel.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/12.
//

import Foundation


// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? value.decode(Int.self, forKey: .id)) ?? 0
        main = (try? value.decode(String.self, forKey: .main)) ?? ""
        weatherDescription = (try value.decode(String.self, forKey: .weatherDescription))
        icon = (try? value.decode(String.self, forKey: .icon)) ?? ""
    }
}

enum Icon: String, Codable {
    case the01D = "01d"
    case the04D = "04d"
    case the04N = "04n"
    case the10D = "10d"
    case the10N = "10n"
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case 맑음 = "맑음"
    case 보통비 = "보통 비"
    case 실비 = "실 비"
    case 온흐림 = "온흐림"
    case 튼구름 = "튼구름"
}
