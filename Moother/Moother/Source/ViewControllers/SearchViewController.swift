//
//  SearchViewController.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/06.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private var backgroundView = UIView()
    private var infoLabel = UILabel().then {
        $0.text = "도시, 우편번호 또는 공항 위치 입력"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    private let searchBarContainerView = UIView().then {
        $0.backgroundColor = .searchBarContainer
    }
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색"
    }
    private let searchResultTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
    }
    
    // MARK: - Properties
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setDelegation()
        registerCell()
    }
    
    // MARK: - Function
    
    private func configureUI() {
        
        view.addSubviews(backgroundView, searchResultTableView, searchBarContainerView)
        searchBarContainerView.addSubviews(infoLabel, searchBar, cancelButton)
        
        searchBarContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(searchBarContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        setBlurEffect()
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.leading.equalTo(searchBar.snp.trailing).offset(16)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarContainerView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        setSearchBar()
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        backgroundView.addSubview(visualEffectView)
    }
    
    private func setSearchBar() {
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        searchBar.searchTextField.backgroundColor = .searchBar
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        searchBar.barTintColor = .searchBarContainer
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    private func setDelegation() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    private func registerCell() {
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: Const.Cell.searchResultTableViewCell)
    }
    
}

// MARK:- Search Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultTableView.reloadData()
        }
        
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - MKMapKit Delegate

extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results

        searchResultTableView.reloadData()
    }
}

// MARK: - UITableView Delegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchResultTableView.dequeueReusableCell(withIdentifier: Const.Cell.searchResultTableViewCell, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        cell.configureUI()
        let searchResult = searchResults[indexPath.row]
        cell.setData(location: searchResult.title)
        
        /// 검색 결과 중 검색창에 입력한 부분만 하이라이팅
        if let highlightText = searchBar.searchTextField.text {
            let attributtedString = NSMutableAttributedString(string: cell.locationLabel.text!)
            attributtedString.addAttribute(.foregroundColor, value: UIColor.white, range: (cell.locationLabel.text! as NSString).range(of: highlightText))
            
            cell.locationLabel.attributedText = attributtedString
        }
        
        return cell
    }
    
}
