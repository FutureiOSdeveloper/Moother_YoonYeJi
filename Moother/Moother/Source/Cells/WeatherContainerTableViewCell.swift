//
//  WeatherContainerTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit
import SnapKit
import Then

class WeatherContainerTableViewCell: UITableViewCell {
    
    var weatherContainerTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        configureUI()
    }
    
    func configureUI() {
        addSubviews(weatherContainerTableView)
        
        weatherContainerTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        weatherContainerTableView.delegate = self
        weatherContainerTableView.dataSource = self
        
        weatherContainerTableView.register(DayTableViewCell.self, forCellReuseIdentifier: Const.cell.dayTableViewCell)
        weatherContainerTableView.register(WeatherInfoTableViewCell.self, forCellReuseIdentifier: Const.cell.weatherInfoTableViewCell)
    }
    
    func setTableViewEnableScroll(isScrollEnabled: Bool) {
        weatherContainerTableView.isScrollEnabled = isScrollEnabled
    }
    
}

extension WeatherContainerTableViewCell: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 80
        case 1:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 60
        default:
            return 40
        }
    }
}

extension WeatherContainerTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = weatherContainerTableView.dequeueReusableCell(withIdentifier: Const.cell.dayTableViewCell, for: indexPath) as? DayTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case 1:
            guard let cell = weatherContainerTableView.dequeueReusableCell(withIdentifier: Const.cell.weatherInfoTableViewCell, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell() }
            cell.configureUI()
        
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        default:
            return UITableViewCell()
        }
    }
}
