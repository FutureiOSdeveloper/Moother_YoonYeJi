//
//  TopView.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit

class TopView: UIView {
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let cityLabel = UILabel().then {
        $0.text = "광명시"
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.textColor = .white
    }
    private let temperatureLabel = UILabel().then {
        $0.text = "27"
        $0.font = UIFont.systemFont(ofSize: 80)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(containerView)
        containerView.addSubviews(cityLabel, temperatureLabel)
        
        cityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
}
