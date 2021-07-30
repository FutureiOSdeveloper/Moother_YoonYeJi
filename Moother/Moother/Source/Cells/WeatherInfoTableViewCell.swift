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
    private var titleLabel2 = UILabel().then {
        $0.text = "일출"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    private var infoLabel2 = UILabel().then {
        $0.text = "오전 5:34"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 25)
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
        addSubviews(separatorLabel, titleLabel, infoLabel, titleLabel2, infoLabel2)
        
        separatorLabel.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(20)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        titleLabel2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-170)
        }
        infoLabel2.snp.makeConstraints {
            $0.top.equalTo(titleLabel2.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel2.snp.leading)
        }
    }

}
