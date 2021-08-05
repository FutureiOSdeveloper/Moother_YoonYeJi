//
//  WeatherListFooterView.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/06.
//

import UIKit

class WeatherListFooterView: UIView {

    private var temperatureToggleButton = UIButton().then {
        $0.setTitle("°C / °F", for: .normal)
    }
    
    private var weatherChannelButton = UIButton().then {
        $0.setImage(Const.Image.weatherChannelImage, for: .normal)
        $0.alpha = 0.6
    }
    
    private var searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(temperatureToggleButton, weatherChannelButton, searchButton)
        
        temperatureToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        weatherChannelButton.snp.makeConstraints {
            $0.top.equalTo(temperatureToggleButton.snp.top).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
}
