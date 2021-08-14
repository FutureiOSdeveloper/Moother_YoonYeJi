//
//  LabelTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit

class TodayWeatherTableViewCell: UITableViewCell {
    
    private var todayWeatherLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureUI() {
        addSubviews(todayWeatherLabel)
  
        todayWeatherLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
        }

    }

    public func setTodayLabel(todayInfo: Today) {
        todayWeatherLabel.text = "오늘: 오늘 날씨는 \(todayInfo.description), 현재 기온은 \(todayInfo.currentTemp)°이며 최고 기온은 31°입니다."
    }
    
    public func setLabel(text: String) {
        todayWeatherLabel.text = text
    }
}
