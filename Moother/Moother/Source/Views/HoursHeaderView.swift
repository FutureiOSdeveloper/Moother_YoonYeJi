//
//  HoursHeaderView.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit

class HoursHeaderView: UIView {
    
    // MARK: - UI Properites
    
    private var separatorTopLabel = UIView().then {
        $0.backgroundColor = .white
    }
    private var separatorBottomLabel = UIView().then {
        $0.backgroundColor = .white
    }
    private var HoursCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.contentInset = .zero
        $0.collectionViewLayout = layout
    }
    
    // MARK: - Properties
    
    private var hourData: [AppHour] = [AppHour(hour: "", temperature: 0, weatherIcon: "")]
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func configureUI() {
        addSubviews(HoursCollectionView, separatorTopLabel, separatorBottomLabel)
        
        HoursCollectionView.snp.makeConstraints {
            $0.top.equalTo(120)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        separatorTopLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        separatorBottomLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        HoursCollectionView.dataSource = self
        HoursCollectionView.delegate = self
        HoursCollectionView.register(HoursCollectionViewCell.self, forCellWithReuseIdentifier: Const.Cell.hoursCollectionViewCell)
    }
    
    public func setHourData(hour: [AppHour]) {
        hourData = hour
        HoursCollectionView.reloadData()
    }
    
}

extension HoursHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HoursHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = HoursCollectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.hoursCollectionViewCell, for: indexPath) as? HoursCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureUI()
        cell.setData(hour: hourData[indexPath.row])
        
        return cell
    }
}

extension HoursHeaderView: UICollectionViewDelegate {
}
