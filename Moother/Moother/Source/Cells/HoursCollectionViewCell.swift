//
//  HoursCollectionViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/29.
//

import UIKit
import SnapKit
import Then


class HoursCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private var hourLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .white
    }
    private var weatherImageView = UIImageView().then {
        $0.image = Const.Image.weatherIcon
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    private var temperatureLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .white
    }
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    public func configureUI() {
        contentView.addSubviews(hourLabel, weatherImageView, temperatureLabel)
        
        hourLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(hourLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    public func setData(hour: AppHour) {
        hourLabel.text = hour.hour
        temperatureLabel.text = "\(Int(hour.temperature))°"
        weatherImageView.image = UIImage(systemName: hour.weatherIcon)
    }

}
