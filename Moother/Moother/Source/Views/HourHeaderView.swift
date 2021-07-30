//
//  HourHeaderView.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit

class HourHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        guard let headerCell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.hoursTableViewCell) as? HoursTableViewCell else { return }
        headerCell.configureUI()
        headerView.addSubview(headerCell)
        headerCell.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        return headerView
    }
    
}
