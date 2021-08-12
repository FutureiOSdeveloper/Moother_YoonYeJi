//
//  WeatherViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/25.
//

import UIKit

import SnapKit
import Then

enum Size {
    static let headerHeight: CGFloat = 260
    static let minimumOffset: CGFloat = 60
    static let maximumOffset: CGFloat = 130
    static let hoursSectionHeight: CGFloat = 240
    static let separatorHeight: CGFloat = 0.5
}

class WeatherViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let weatherTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private let cityLabel = UILabel().then {
        $0.text = "광명시"
        $0.font = UIFont.systemFont(ofSize: 32, weight: .light)
        $0.textColor = .white
    }
    private let statusLabel = UILabel().then {
        $0.text = "매우 맑음"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .white
    }
    private let temperatureLabel = UILabel().then {
        $0.text = "27°"
        $0.font = UIFont.systemFont(ofSize: 80, weight: .thin)
        $0.textColor = .white
    }
    private let backgroundImageView = UIImageView().then {
        $0.image = Const.Image.backgroundImage
    }
    private let minAndMaxTemperatureLabel = UILabel().then {
        $0.text = "최고:22° 최저:12°"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .white
    }
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    private let addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Properties
    
    public var delegate: LocationModalDelegate?
    
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
        view.addSubviews(backgroundImageView, weatherTableView, cityLabel, temperatureLabel, statusLabel, minAndMaxTemperatureLabel)
        
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
            $0.centerX.equalToSuperview().offset(10)
        }
        
        minAndMaxTemperatureLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        weatherTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(-60)
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
        weatherTableView.register(DayTableViewCell.self, forCellReuseIdentifier: Const.Cell.dayTableViewCell)
        weatherTableView.register(TodayWeatherTableViewCell.self, forCellReuseIdentifier: Const.Cell.todayWeatherTableViewCell)
        weatherTableView.register(WeatherInfoTableViewCell.self, forCellReuseIdentifier: Const.Cell.weatherInfoTableViewCell)
    }
    
    private func addCancelAndAddButton() {
        view.addSubviews(cancelButton, addButton)
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            cancelButton.addTarget(self, action: #selector(touchCancelButton(_:)), for: .touchUpInside)
        }
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            addButton.addTarget(self, action: #selector(touchAddButton(_:)), for: .touchUpInside)
        }
    }
    
    public func updateWeatherInfo(city: String) {
        addCancelAndAddButton()
        cityLabel.text = city
    }
    
    @objc
    private func touchAddButton(_ button: UIButton) {
        if let location = cityLabel.text {
            delegate?.addLocation(location)
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func touchCancelButton(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WeatherViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Size.headerHeight / 2 - scrollView.contentOffset.y
        let percent = offset / 100
        
        /// 라벨 top Constraint, alpha값 조절
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < Size.headerHeight {
            cityLabel.snp.updateConstraints {
                $0.top.equalToSuperview().offset(max(offset, Size.minimumOffset))
            }
            minAndMaxTemperatureLabel.alpha = percent / 2
            temperatureLabel.alpha = percent / 2 + 0.2
        } else if scrollView.contentOffset.y <= 0 {
            cityLabel.snp.updateConstraints {
                $0.top.equalToSuperview().offset(min(offset, Size.maximumOffset))
            }
            minAndMaxTemperatureLabel.alpha = percent
            temperatureLabel.alpha = percent + 0.2
        }
        
        /// cell mask
        for cell in self.weatherTableView.visibleCells {
            let paddingToDisapear = CGFloat(Size.hoursSectionHeight)
            let hiddenFrameHeight = scrollView.contentOffset.y + paddingToDisapear - cell.frame.origin.y
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                if let customCell = cell as? DayTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < Size.hoursSectionHeight {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: Size.headerHeight), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return Size.headerHeight
        case 1:
            return Size.hoursSectionHeight
        default:
            return Size.separatorHeight
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
        case 1: /// 날짜별 날씨셀
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.Cell.dayTableViewCell, for: indexPath) as? DayTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case 2: /// 오늘 날씨셀
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.Cell.todayWeatherTableViewCell, for: indexPath) as? TodayWeatherTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case 3: /// 날씨 Detail Info 셀
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.Cell.weatherInfoTableViewCell, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            return cell
        case 4:
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Const.Cell.todayWeatherTableViewCell, for: indexPath) as? TodayWeatherTableViewCell else { return UITableViewCell() }
            cell.configureUI()
            cell.selectionStyle = .none
            cell.setLabel(text: "광명시 날씨.")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

