//
//  HoursTableViewCell.swift
//  Moother
//
//  Created by 윤예지 on 2021/07/29.
//

import UIKit
import SnapKit
import Then

class HoursTableViewCell: UITableViewCell {

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        addSubviews(separatorTopLabel, separatorBottomLabel, HoursCollectionView)
        
        separatorTopLabel.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        separatorBottomLabel.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        HoursCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        HoursCollectionView.dataSource = self
        HoursCollectionView.delegate = self
        HoursCollectionView.register(HoursCollectionViewCell.self, forCellWithReuseIdentifier: Const.cell.hoursCollectionViewCell)
    }
}

extension HoursTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HoursTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = HoursCollectionView.dequeueReusableCell(withReuseIdentifier: Const.cell.hoursCollectionViewCell, for: indexPath) as? HoursCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureUI()
        
        return cell
    }
}

extension HoursTableViewCell: UICollectionViewDelegate {
}
