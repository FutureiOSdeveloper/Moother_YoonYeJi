//
//  WeatherListTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    
    private var timeLabel = UILabel().then {
        $0.text = "오후 10:32"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .white
    }
    private var locationLabel = UILabel().then {
        $0.text = "광명시"
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textColor = .white
    }
    private var temperatureLabel = UILabel().then {
        $0.text = "27°"
        $0.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        $0.textColor = .white
    }
    
    // MARK: - Properties
    
    public var isFirstCell: Bool = false
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Function
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureUI(isFirstCell: Bool) {
        addSubviews(timeLabel, locationLabel, temperatureLabel)
        self.isFirstCell = isFirstCell
        
        if isFirstCell {
            timeLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(50)
                $0.leading.equalToSuperview().offset(10)
            }
        } else {
            timeLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.leading.equalToSuperview().offset(10)
            }
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(2)
            $0.leading.equalTo(timeLabel.snp.leading)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }

}
