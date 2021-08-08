//
//  WeatherListFooterView.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/06.
//

import UIKit

class WeatherListFooterView: UIView {

    public var temperatureSwitchButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("℃ / ℉", for: .normal)
    }
    
    private var weatherChannelButton = UIButton().then {
        $0.setImage(Const.Image.weatherChannelImage, for: .normal)
        $0.alpha = 0.6
    }
    
    private var searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
    }
    
    public var delegateOfSwitchButton: TemperatureDelegate?
    public var delegateOfSearchButton: SearchDelegate?
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        setButtonEvent()
        setSwitchButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func configureUI() {
        addSubviews(temperatureSwitchButton, weatherChannelButton, searchButton)
        
        temperatureSwitchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        weatherChannelButton.snp.makeConstraints {
            $0.top.equalTo(temperatureSwitchButton.snp.top).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func setSwitchButton() {
        let buttonText = "℃ / ℉"
        let normalButtonText = NSMutableAttributedString(string: buttonText)
        normalButtonText.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 2, length: 3))
        let selectedButtonText = NSMutableAttributedString(string: buttonText)
        selectedButtonText.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 3))

        temperatureSwitchButton.setAttributedTitle(normalButtonText, for: .normal)
        temperatureSwitchButton.setAttributedTitle(selectedButtonText, for: .selected)
    }
    
    private func setButtonEvent() {
        temperatureSwitchButton.addTarget(self, action: #selector(touchTemperatureSwitchButton(_:)), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(touchSearchButton(_:)), for: .touchUpInside)
    }
    
    @objc
    private func touchTemperatureSwitchButton(_ button: UIButton) {
        if temperatureSwitchButton.isSelected {
            delegateOfSwitchButton?.switchButtonDidSelected(unit: .celsius)
        } else {
            delegateOfSwitchButton?.switchButtonDidSelected(unit: .fahrenheit)
        }
    }
    
    @objc
    private func touchSearchButton(_ button: UIButton) {
        delegateOfSearchButton?.searchButtonDidSelected()
    }
}
