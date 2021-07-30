//
//  DayTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/29.
//

import UIKit
import SnapKit
import Then

class DayTableViewCell: UITableViewCell {
    
    private var dayLabel = UILabel().then {
        $0.text = "금요일"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    private var weatherImage = UIImageView().then {
        $0.image = Const.Image.weatherIcon
    }
    private var humidityLabel = UILabel().then {
        $0.text = "70%"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .systemBlue
    }
    private var maximumTemperatureLabel = UILabel().then {
        $0.text = "33"
        $0.textColor = .white
    }
    private var minimumTemperatureLabel = UILabel().then {
        $0.text = "26"
        $0.textColor = .lightGray
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        addSubviews(dayLabel, weatherImage, humidityLabel, maximumTemperatureLabel, minimumTemperatureLabel)
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
        }
        
        weatherImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(weatherImage.snp.trailing).offset(5)
        }
        
        maximumTemperatureLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(humidityLabel.snp.trailing).offset(50)
        }
        
        minimumTemperatureLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(maximumTemperatureLabel.snp.trailing).offset(20)
        }
        
        
    }

}
