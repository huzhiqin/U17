//
//  ReadCollectionViewCell.swift
//  U17
//
//  Created by lyw on 2020/5/25.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit
import Kingfisher

// 设置占位图
extension UIImageView: Placeholder {}

class ReadCollectionViewCell: BaseCollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var placeholder: UIImageView = {
        let placeholder = UIImageView(image: UIImage(named: "yaofan"))
        placeholder.contentMode = .center
        return placeholder
    }()
    
    override func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    var model: Image_list? {
        didSet {
            guard let model = model else { return }
            imageView.image = nil
            imageView.kf.setImage(urlString: model.location, placeholder: placeholder)
        }
    }
}
