//
//  WeatherPageViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit

class WeatherPageViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal)
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
    }
    private let pageToolbar = UIToolbar().then {
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
    
    private var locationCount = 5
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageViewController()
        setPageControl()
        setUI()
        setToolbarItem()
        setButtonEvent()
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
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }

        weatherListButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(30)
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
        return viewController
    }
    
    private func setPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let weatherViewController = instantiateViewController(index: 0)
        pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = locationCount
    }
    
    // MARK: - @objc

    @objc
    private func touchWeatherChannelButton(_ button: UIButton) {
        if let weatherSiteURL = URL(string: "https://weather.com/ko-KR/weather/today/l/37.48,126.86?par=apple_widget&locale=ko_KR") {
            UIApplication.shared.open(weatherSiteURL)
        }
    }
    
    @objc
    private func touchWeatherListButton(_ button: UIButton) {
        let weatherListViewController = WeatherListViewController()
        weatherListViewController.modalPresentationStyle = .overFullScreen

        weatherListViewController.delegate = self
        
        self.present(weatherListViewController, animated: true, completion: nil)
    }
}

extension WeatherPageViewController: LocationIndexProtocol {
    func didSelectLocation(at index: Int) {
        let weatherViewController = WeatherViewController()
    
        self.pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = index
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
        
        let nextIndex = index > 0 ? index - 1 : locationCount - 1
        
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % locationCount
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
}
