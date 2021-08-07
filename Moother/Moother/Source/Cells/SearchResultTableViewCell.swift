//
//  SearchResultTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/06.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    public var locationLabel = UILabel().then {
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
    
    public func configureUI() {
        addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    public func setData(location: String) {
        locationLabel.text = location
    }

}
