//
//  WeatherPageViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/30.
//

import UIKit

class WeatherPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    private let pageControlView = UIView().then {
        $0.backgroundColor = .white
    }
    private let pageControlSeparatorView = UIView().then {
        $0.backgroundColor = .white
    }
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageViewController()
        setPageControl()
        configureUI()
    }
    
    // MARK: - Function
    
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
        
        addChild(weatherViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = 5
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureUI() {
        view.addSubview(pageControlSeparatorView)
        pageControlSeparatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(-50)
            $0.height.equalTo(1)
        }
    }
    
}


extension WeatherPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        let nextIndex = index > 0 ? index - 1 : 5 - 1
        
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % 5
        let nextViewController = instantiateViewController(index: nextIndex)
        return nextViewController
    }
}

extension WeatherPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}
