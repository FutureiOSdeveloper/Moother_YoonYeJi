//
//  WeatherAPI.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/13.
//

import Foundation
import Moya

public class WeatherAPI {
    
    static let shared = WeatherAPI()
    var weatherProvider = MoyaProvider<WeatherService>()
    
    public init() {}
    
    func getWeatherData(latitude: Double, longitude: Double, exclude: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        weatherProvider.request(.getWeatherInfo(latitude, longitude, exclude)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            return isValidData(data: data)
        case 400..<500:
            return .requestErr(data)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(WeatherResponse.self, from: data) else {
            return .pathErr
        }
        
        return .success(decodedData)
    }
    
}
