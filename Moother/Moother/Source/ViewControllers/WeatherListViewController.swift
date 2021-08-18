//
//  WeatherListViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit
import CoreData

class WeatherListViewController: UIViewController {

    // MARK: - UI Properties
    
    private var weatherListTableView = UITableView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .black
    }
    private let footerView = WeatherListFooterView()
    
    // MARK: - Properties
    
    public var delegate: LocationTableViewDelegate?
    public var temperature: Int = 27
    private var locationWeatherInfo: [WeatherResponse] = []
    private var locationName: [AppLocation] = []
    private var temperatureList: [Int] = []
    private lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTemperature()
        configureUI()
        setDelegation()
        registerCell()
    }
    
    // MARK: - Function
    
    private func configureUI() {
        view.addSubviews(weatherListTableView)
        
        weatherListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setDelegation() {
        weatherListTableView.delegate = self
        weatherListTableView.dataSource = self
    }
    
    private func registerCell() {
        weatherListTableView.register(WeatherListTableViewCell.self, forCellReuseIdentifier: Const.Cell.weatherListTableViewCell)
    }
    
    public func setLocationInfo(weatherInfo: [WeatherResponse], nameInfo: [AppLocation]) {
        locationWeatherInfo = weatherInfo
        locationName = nameInfo
    }
    
    public func reloadTableView() {
        weatherListTableView.reloadData()
    }
    
    public func setTemperature() {
        locationWeatherInfo.forEach {
            temperatureList.append(Int($0.current.temp))
        }
    }
    
    // MARK: - Core Data
    
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        let result = try! manageContext.fetch(fetchRequest)
        
        return result
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        manageContext.delete(object)
        do {
            try manageContext.save()
            return true
        } catch {
            return false
        }
    }
    
}

extension WeatherListViewController: TemperatureDelegate {
    
    func switchButtonDidSelected(unit temperature: temperature) {
       
        if temperature == .fahrenheit {
            convertCeltoFah()
        } else {
            convertFahToCel()
        }
        
        reloadTableView()
        
        if temperature == .fahrenheit {
            footerView.temperatureSwitchButton.isSelected = true
        } else {
            footerView.temperatureSwitchButton.isSelected = false
        }
    
    }
    
    private func convertCeltoFah() {
        for i in 0...locationWeatherInfo.count - 1 {
            temperatureList[i] = Int(round(Double(temperatureList[i]) * 1.8) + 32)
        }
    }
    
    private func convertFahToCel() {
        for i in 0...locationWeatherInfo.count - 1 {
            temperatureList[i] = Int(round(Double(temperatureList[i]) - 32) / 1.8)
        }
    }
    
}

extension WeatherListViewController: SearchDelegate {
    
    func searchButtonDidSelected() {
        let searchViewController = SearchViewController()
        self.present(searchViewController, animated: true, completion: nil)
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 104
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView.delegateOfSwitchButton = self
        footerView.delegateOfSearchButton = self
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(object: list[indexPath.row])
            list.remove(at: indexPath.row)
            locationWeatherInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            delegate?.tableViewDeleteButtonDidSelected(tableView, at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewDidSelected(tableView, at: indexPath.row)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationWeatherInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherListTableView.dequeueReusableCell(withIdentifier: Const.Cell.weatherListTableViewCell, for: indexPath) as? WeatherListTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.configureUI(isFirstCell: true)
            cell.backgroundColor = .lightBlue
        } else {
            cell.configureUI(isFirstCell: false)
            cell.backgroundColor = .gray
        }
        
        cell.setData(time: "10:32", city: locationName[indexPath.row].name, temperature: temperatureList[indexPath.row])
        
        return cell
    }

}
