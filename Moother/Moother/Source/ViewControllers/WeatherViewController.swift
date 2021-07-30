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
        view.addSubviews(backgroundImageView, weatherTableView, cityLabel, temperatureLabel)
        
        cityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(10)
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
        weatherTableView.register(HoursTableViewCell.self, forCellReuseIdentifier: Const.cell.hoursTableViewCell)
        weatherTableView.register(WeatherContainerTableViewCell.self, forCellReuseIdentifier: Const.cell.weatherContainerTableViewCell)
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        
        guard let weatherContainerCell = weatherTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? WeatherContainerTableViewCell else { return }
        
        let percent = (200 - scrollView.contentOffset.y)
        
        /// 라벨 top Constraint, alpha값 조절
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 287 {
            cityLabel.snp.updateConstraints {
                $0.top.equalToSuperview().offset(max(percent, 80))
            }
            temperatureLabel.alpha = percent / 100
        } else if scrollView.contentOffset.y <= 0 {
            cityLabel.snp.updateConstraints {
                $0.top.equalToSuperview().offset(min(percent, 200))
            }
            temperatureLabel.alpha = percent / 100
        }
        
        /// 메인 테이블 스크롤 offset에 따라 스크롤 분기
        if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < 303 {
            weatherContainerCell.setTableViewEnableScroll(isScrollEnabled: false)
        } else {
            weatherContainerCell.setTableViewEnableScroll(isScrollEnabled: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 400
        case 1:
            return 100
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 550
        default:
            return 50
        }
    }
    
}

extension WeatherViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = UIView()
            view.backgroundColor = .none
            return view
        case 1:
            let headerView = UIView()
            guard let headerCell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.hoursTableViewCell) as? HoursTableViewCell else { return UIView() }
            headerCell.configureUI()
            headerView.addSubview(headerCell)
            headerCell.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.cell.weatherContainerTableViewCell, for: indexPath) as? WeatherContainerTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

