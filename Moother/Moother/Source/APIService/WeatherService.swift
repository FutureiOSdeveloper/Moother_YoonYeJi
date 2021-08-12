//
//  WeatherService.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation
import Moya

enum WeatherService {
    case getWeatherInfo(_ lat: Double, _ lon: Double, _ exclude: String)
}

extension WeatherService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getWeatherInfo(_, _, _):
            return Const.URL.oneCallURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeatherInfo(_, _, _):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            switch self {
            case let .getWeatherInfo(lat, lon, exclude):
                return .requestParameters(
                    parameters: [ "lat": lat, "lon": lon, "exclude": exclude, "units": "metric", "appid": apiKey, "lang": "kr"], encoding: URLEncoding.queryString)
            }
        }
        return .requestPlain
    }
    
    var headers: [String : String]? {
        switch self {
        case .getWeatherInfo(_, _, _):
            return nil
        }
    }
    
}
