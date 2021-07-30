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
    
    private var hourLabel = UILabel().then {
        $0.text = "오전 3시"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .white
    }
    private var weatherImageView = UIImageView().then {
        $0.image = Const.Image.weatherIcon
    }
    private var temperatureLabel = UILabel().then {
        $0.text = "26"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubviews(hourLabel, weatherImageView, temperatureLabel)
        
        hourLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(hourLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }

}
