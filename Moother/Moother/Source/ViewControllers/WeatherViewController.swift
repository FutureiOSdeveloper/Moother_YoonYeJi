//
//  WeatherViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/25.
//

import UIKit

import SnapKit
import Then

class WeatherViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let weatherTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private let cityLabel = UILabel().then {
        $0.text = "광명시"
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.textColor = .white
    }
    private let statusLabel = UILabel().then {
        $0.text = "매우 맑음"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textColor = .white
    }
    private let temperatureLabel = UILabel().then {
        $0.text = "27"
        $0.font = UIFont.systemFont(ofSize: 80)
        $0.textColor = .white
    }
    private let backgroundImageView = UIImageView().then {
        $0.image = Const.Image.backgroundImage
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUI()
        setDelegation()
        registerCell()
    }
    
    // MARK: - Function
    
    private func setUI() {
        view.addSubviews(backgroundImageView, weatherTableView, cityLabel, temperatureLabel, statusLabel)
        
        cityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        weatherTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(-50)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setDelegation() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    private func registerCell() {
        weatherTableView.register(DayTableViewCell.self, forCellReuseIdentifier: Const.cell.dayTableViewCell)
        weatherTableView.register(TodayWeatherTableViewCell.self, forCellReuseIdentifier: Const.cell.todayWeatherTableViewCell)
        weatherTableView.register(WeatherInfoTableViewCell.self, forCellReuseIdentifier: Const.cell.weatherInfoTableViewCell)
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = (180 - scrollView.contentOffset.y)
        let percent = offset / 100
        
        /// 라벨 top Constraint, alpha값 조절
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 287 {
            cityLabel.snp.updateConstraints {
                $0.top.equalToSuperview().offset(max(offset, 60))
            }
            temperatureLabel.alpha = percent
        } else if scrollView.contentOffset.y <= 0 {
            cityLabel.snp.updateConstraints {
                $0.top.equalToSuperview().offset(min(offset, 180))
            }
            temperatureLabel.alpha = percent
        }
        
        /// cell mask
        for cell in self.weatherTableView.visibleCells {
            let paddingToDisapear = CGFloat(240)
            let hiddenFrameHeight = scrollView.contentOffset.y + paddingToDisapear - cell.frame.origin.y
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                print(hiddenFrameHeight)
                if let customCell = cell as? DayTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 360
        case 1:
            return 240
        default:
            return 0.5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 9
        case 2:
            return 1
        case 3:
            return 5
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 30
        case 3:
            return 60
        default:
            return UITableView.automaticDimension
        }
    }

}

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = UIView()
            view.backgroundColor = .none
            return view
        case 1:
            return HoursHeaderView()
        case 2:
            return SeparatorLineView()
        case 3:
            return SeparatorLineView()
        case 4:
            return SeparatorLineView()
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.dayTableViewCell, for: indexPath) as? DayTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.todayWeatherTableViewCell, for: indexPath) as? TodayWeatherTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case 3:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.weatherInfoTableViewCell, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case 4:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.todayWeatherTableViewCell, for: indexPath) as? TodayWeatherTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            cell.setLabel(text: "광명시 날씨.")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

