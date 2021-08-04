//
//  WeatherInfoTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/29.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {

    private var separatorLabel = UIView().then {
        $0.backgroundColor = .white
    }
    private var weatherDetailInfoView = WeatherDetailInfoView()
    private var weatherDetailInfoView2 = WeatherDetailInfoView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureUI() {
        addSubviews(separatorLabel, weatherDetailInfoView, weatherDetailInfoView2)
        
        separatorLabel.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        weatherDetailInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        weatherDetailInfoView2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(UIScreen.main.bounds.width/2)
        }
       
    }

}
