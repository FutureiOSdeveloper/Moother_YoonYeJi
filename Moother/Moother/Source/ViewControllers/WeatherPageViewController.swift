//
//  WeatherPageViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit
import CoreData

class WeatherPageViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal)
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
    }
    private let pageToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)).then {
        $0.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    }
    private let weatherChannelButton = UIButton().then {
        $0.setImage(Const.Image.weatherChannelImage, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.alpha = 0.5
    }
    private let weatherListButton = UIButton().then {
        $0.setImage(UIImage(systemName: "list.dash"), for: .normal)
        $0.tintColor = .white
        $0.alpha = 0.5
    }
    private let separatorView = SeparatorLineView()
    
    // MARK: - Properties
    
    private var index = 0
    private var weatherInfo: WeatherResponse?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var container: NSPersistentContainer!
    private var locationList: [AppLocation] = []
    private var locationWeatherInfoList: [WeatherResponse] = []
    private let weatherListViewController = WeatherListViewController()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPersistentContainer()
        fetchContent()
        getAllLocationWeatherInfo()
        setPageViewController(index: index)
        setPageControl()
        setUI()
        setToolbarItem()
        setButtonEvent()
        addObservers()
    }
    
    // MARK: - Function
    
    private func setUI() {
        view.addSubviews(pageToolbar, separatorView)
        
        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
        
        pageToolbar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        weatherChannelButton.snp.makeConstraints {
            $0.height.width.equalTo(30)
        }
        
        weatherListButton.snp.makeConstraints {
            $0.height.width.equalTo(30)
        }
    }
    
    private func setToolbarItem() {
        var items: [UIBarButtonItem] = []
        let flexibleSpaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let weatherChannelBarButtonItem = UIBarButtonItem(customView: weatherChannelButton)
        let pageControllBarButtonItem = UIBarButtonItem(customView: pageControl)
        let weatherListBarButtonItem = UIBarButtonItem(customView: weatherListButton)
        
        items.append(weatherChannelBarButtonItem)
        items.append(flexibleSpaceBarButtonItem)
        items.append(pageControllBarButtonItem)
        items.append(flexibleSpaceBarButtonItem)
        items.append(weatherListBarButtonItem)
        
        pageToolbar.setItems(items, animated: true)
    }
    
    private func setButtonEvent() {
        weatherChannelButton.addTarget(self, action: #selector(touchWeatherChannelButton(_:)), for: .touchUpInside)
        weatherListButton.addTarget(self, action: #selector(touchWeatherListButton(_:)), for: .touchUpInside)
    }
    
    private func instantiateViewController(index: Int) -> UIViewController {
        let viewController = WeatherViewController()
        viewController.view.tag = index
        viewController.getWeatherInfo(lat: locationList[index].latitude, lon: locationList[index].longitude, exclude: "minutely,alerts")
        return viewController
    }
    
    private func setPageViewController(index: Int) {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let weatherViewController = instantiateViewController(index: index)
        pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func getAllLocationWeatherInfo() {
        locationList.forEach {
            getWeatherInfo(lat: $0.latitude, lon: $0.longitude, exclude: "minutely,alerts")
        }
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = locationList.count
    }
    
    private func changeCurrentPosition(at index: Int) {
        let weatherViewController = instantiateViewController(index: index)
        pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = index
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addButtonClicked), name: NSNotification.Name("addButtonClicked"), object: nil)
    }
    
    // MARK: - @objc
    
    @objc
    private func addButtonClicked() {
        locationWeatherInfoList.removeAll()
        fetchContent()
        setPageControl()
        getAllLocationWeatherInfo()
    }
    
    @objc
    private func touchWeatherChannelButton(_ button: UIButton) {
        if let weatherSiteURL = URL(string: "https://weather.com/ko-KR/weather/today/l/37.48,126.86?par=apple_widget&locale=ko_KR") {
            UIApplication.shared.open(weatherSiteURL)
        }
    }
    
    @objc
    private func touchWeatherListButton(_ button: UIButton) {
        weatherListViewController.modalPresentationStyle = .overCurrentContext
        weatherListViewController.delegate = self
        weatherListViewController.setLocationInfo(weatherInfo: locationWeatherInfoList, nameInfo: locationList)
        
        self.present(weatherListViewController, animated: true, completion: nil)
    }
    
    // MARK: - Core Data
    
    private func setPersistentContainer() {
        container = appDelegate.persistentContainer
    }
    
    private func fetchContent() {
        locationList.removeAll()
        do {
            let location = try self.container.viewContext.fetch(Location.fetchRequest()) as! [Location]
            location.forEach {
                locationList.append(AppLocation(name: $0.name as! String, latitude: $0.latitude as! Double, longitude: $0.longtitude as! Double))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension WeatherPageViewController: LocationTableViewDelegate {
    func tableViewDeleteButtonDidSelected(_ tableView: UITableView, at index: Int) {
        fetchContent()
        setPageControl()
    }
    
    func tableViewDidSelected(_ tableView: UITableView, at index: Int) {
        changeCurrentPosition(at: index)
    }
}

extension WeatherPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        
        if let viewController = pageViewController.viewControllers?.first {
            pageControl.currentPage = viewController.view.tag
        }
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        let nextIndex = index > 0 ? index - 1 : locationList.count - 1
    
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % locationList.count
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
    
}

extension WeatherPageViewController {
    
    func getWeatherInfo(lat: Double, lon: Double, exclude: String) {
        WeatherAPI.shared.getWeatherData(latitude: lat, longitude: lon, exclude: exclude) { [self] (response) in
            switch response {
            case .success(let weatherInfo):
                if let data = weatherInfo as? WeatherResponse {
                    locationWeatherInfoList.append(data)
                }
                if locationWeatherInfoList.count == locationList.count { /// 여기 리팩토링 방법 찾아보기
                    weatherListViewController.setLocationInfo(weatherInfo: locationWeatherInfoList, nameInfo: locationList)
                    weatherListViewController.reloadTableView()
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


