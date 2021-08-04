//
//  WeatherPageViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit

class WeatherPageViewController: UIViewController {
    
    // MARK: - Properties
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
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageViewController()
        setPageControl()
        setUI()
        setToolbarItem()
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
        pageControl.numberOfPages = 5
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
        
        let nextIndex = index > 0 ? index - 1 : 5 - 1
        
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % 5
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
}
