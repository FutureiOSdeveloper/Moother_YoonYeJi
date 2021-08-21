//
//  WeatherViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/25.
//

import UIKit

import SnapKit
import Then
import CoreData

enum Size {
    static let headerHeight: CGFloat = 260
    static let minimumOffset: CGFloat = 75
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
        $0.text = "_ _"
        $0.font = UIFont.systemFont(ofSize: 32, weight: .light)
        $0.textColor = .white
    }
    private let statusLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .white
    }
    private let temperatureLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 80, weight: .thin)
        $0.textColor = .white
    }
    private let backgroundImageView = UIImageView().then {
        $0.image = Const.Image.backgroundImage
    }
    private let minAndMaxTemperatureLabel = UILabel().then {
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
    
    private var hourlyList: [AppHour] = []
    private var dayList: [AppDay] = []
    private var today: Today = Today(description: "", currentTemp: 0, maxTemp: 0)
    private var todayDetailTitle: [[String]] = []
    private var todayDetailInfo: [[Any]] = []
    private var locationInfo = AppLocation(name: "", latitude: 0, longitude: 0)
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var container: NSPersistentContainer!
    private var locationName: String = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegation()
        registerCell()
        setPersistentContainer()
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
        weatherTableView.register(DayTableViewCell.self)
        weatherTableView.register(TodayWeatherTableViewCell.self)
        weatherTableView.register(WeatherInfoTableViewCell.self)
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
    
    public func updateWeatherInfo(lat: Double, lon: Double) {
        addCancelAndAddButton()
        getWeatherInfo(lat: lat, lon: lon, exclude: "minutely,alerts")
    }
    
    func setLocationName(lat: Double, lon: Double) {
        let findLocation = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { [self] (placeMark, error) in
            if let address = placeMark {
                if let name = address[0].locality {
                    locationName = name
                    self.cityLabel.text = name
                } else {
                    if let name = address.last?.name {
                        locationName = name
                        self.cityLabel.text = name
                    }
                }
            }
        }
    }
    
    func setCityLabel(city: String) {
        cityLabel.text = city
    }
    
    // MARK: - objc
    
    @objc
    private func touchAddButton(_ button: UIButton) {
        insertContent(content: locationInfo)
        NotificationCenter.default.post(name: NSNotification.Name("addButtonClicked"), object: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func touchCancelButton(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Core Data
    
    private func setPersistentContainer() {
        container = appDelegate.persistentContainer
    }
    
    private func insertContent(content: AppLocation) {
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: self.container.viewContext)
        
        if let entity = entity {
            let location = NSManagedObject(entity: entity, insertInto: self.container.viewContext)

            location.setValue(locationName, forKey: "name")
            location.setValue(content.latitude, forKey: "latitude")
            location.setValue(content.longitude, forKey: "longtitude")

            do {
                try self.container.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAllLocation() {
        let fetrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetrequest)
    
        do {
            try container.viewContext.execute(batchDeleteRequest)
        } catch {
            print(error.localizedDescription)
        }
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
            return dayList.count
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
            let headerView = HoursHeaderView()
            headerView.setHourData(hour: hourlyList)
            return headerView
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
            let cell: DayTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureUI()
            cell.setData(dayInfo: dayList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case 2: /// 오늘 날씨셀
            let cell: TodayWeatherTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureUI()
            cell.setTodayLabel(todayInfo: today)
            cell.selectionStyle = .none
            return cell
        case 3: /// 날씨 Detail Info 셀
            let cell: WeatherInfoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureUI()
            if todayDetailInfo.count > 1 {
                cell.setData(title: todayDetailTitle[indexPath.row], info: todayDetailInfo[indexPath.row])
            }
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell: TodayWeatherTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureUI()
            cell.selectionStyle = .none
            cell.setLabel(text: cityLabel.text! + " 날씨.")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension WeatherViewController {
    
    // MARK: - TableView Data Setting
    
    func setWeatherInfo(WeatherInfo: WeatherResponse) {
        setHeaderInfo(WeatherInfo: WeatherInfo)
        setHourCellInfo(HourInfo: WeatherInfo.hourly)
        setDayCellInfo(DailyInfo: WeatherInfo.daily)
        setTodayInfo(TodayInfo: WeatherInfo.current)
        setTodayDetailInfo(TodayInfo: WeatherInfo.current)
        weatherTableView.reloadData()
    }
    
    func setHeaderInfo(WeatherInfo: WeatherResponse) {
        cityLabel.text = locationName
        statusLabel.text = WeatherInfo.current.weather[0].weatherDescription
        temperatureLabel.text = "\(Int(WeatherInfo.current.temp))°"
        minAndMaxTemperatureLabel.text = "최고:\(Int(WeatherInfo.daily[0].temp.max))° 최저:\(Int(WeatherInfo.daily[0].temp.min))°"
    }
    
    func setHourCellInfo(HourInfo: [Current]) {
        for hour in 0...24 {
            let hourly = HourInfo[hour]
            hourlyList.append(AppHour(hour: hourly.dt.convertToUTCTime().getFormattedHour(), temperature: hourly.temp, weatherIcon: hourly.weather[0].icon.convertIcon()))
        }
    }
    
    func setDayCellInfo(DailyInfo: [Daily]) {
        for day in 1...7 { /// 다음 날부터 나와야 하기 때문에 1부터 시작
            let date = DailyInfo[day].dt.convertToUTCTime()
            dayList.append(AppDay(weekDay: date.getWeekDay().toKorean(), humidity: DailyInfo[day].humidity, maxTemp: Int(DailyInfo[day].temp.max), minTemp: Int(DailyInfo[day].temp.min)))
        }
    }
    
    func setTodayInfo(TodayInfo: Current) {
        today = Today(description: TodayInfo.weather[0].weatherDescription, currentTemp: Int(TodayInfo.temp), maxTemp: 31)
    }
    
    func setTodayDetailInfo(TodayInfo: Current) {
        let titleList = [["일출", "일몰"], ["비 올 확률", "습도"], ["바람", "체감"], ["강수량", "기압"], ["가시거리", "자외선 지수"]]
        let infoList = [[TodayInfo.sunrise!.convertToUTCTime().getFormattedHM(), TodayInfo.sunset!.convertToUTCTime().getFormattedHM()], ["10%", "\(TodayInfo.humidity)%"], ["동북동 3m/s", "\(Int(TodayInfo.feelsLike))°"], ["0cm", "\(Int(TodayInfo.pressure)) hPa"], ["\(TodayInfo.visibility.convertToKm()) km", Int(TodayInfo.uvi)]]
        
        for i in 0...titleList.count-1 {
            todayDetailTitle.append(titleList[i])
            todayDetailInfo.append(infoList[i])
        }
    }
    
}

extension WeatherViewController {
    
    func getWeatherInfo(lat: Double, lon: Double, exclude: String) {
        WeatherAPI.shared.getWeatherData(latitude: lat, longitude: lon, exclude: exclude) { [self] (response) in
            switch response {
            case .success(let weatherInfo):
                if let data = weatherInfo as? WeatherResponse {
                    setLocationName(lat: data.lat, lon: data.lon)
                    setWeatherInfo(WeatherInfo: data)
                    locationInfo.latitude = data.lat
                    locationInfo.longitude = data.lon
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
}
