//
//  WeatherDetailInfoView.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit

class WeatherDetailInfoView: UIView {

    private var titleLabel = UILabel().then {
        $0.text = "일출"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    private var infoLabel = UILabel().then {
        $0.text = "오전 5:34"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 25)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(titleLabel, infoLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }
    }
    
}
