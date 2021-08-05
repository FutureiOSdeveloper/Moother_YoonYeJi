//
//  WeatherListViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit

class WeatherListViewController: UIViewController {

    private var weatherListTableView = UITableView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .black
    }
    
    public var delegate: LocationIndexProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setDelegation()
        registerCell()
    }
    
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
        return WeatherListFooterView()
    }
}

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLocation(at: indexPath.row)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        
        return cell
    }

}
