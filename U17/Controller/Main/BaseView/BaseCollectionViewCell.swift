//
//  BaseCollectionViewCell.swift
//  U17
//
//  Created by lyw on 2020/5/14.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit
import Reusable

class BaseCollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}

}
