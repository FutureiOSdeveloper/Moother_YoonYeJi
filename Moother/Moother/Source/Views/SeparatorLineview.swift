//
//  SeparatorLineview.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/05.
//

import UIKit

class SeparatorLineView: UIView {
    
    private var separatorView = UIView().then {
        $0.backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(separatorView)
        
        separatorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
    }
}

