//
//  TodayWeatherView.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/29.
//

import UIKit

class FooterView: UIView {
    
    
    private var separatorTopLabel = UIView().then {
        $0.backgroundColor = .white
    }

    private var separatorBottomLabel = UIView().then {
        $0.backgroundColor = .white
    }
    
    private var footerLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(footerLabel, separatorTopLabel, separatorBottomLabel)
        
        footerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        separatorTopLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        separatorBottomLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setFooterLabel(text: String) {
        footerLabel.text = text
    }
}
