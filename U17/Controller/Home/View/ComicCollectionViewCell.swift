//
//  ComicCollectionViewCell.swift
//  U17
//
//  Created by lyw on 2020/5/15.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

// 设置样式
enum ComicCollectionViewCellStyle {
    case none
    case withTitle
    case withTitieAndDesc
}

class ComicCollectionViewCell: BaseCollectionViewCell {
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.gray
        descLabel.font = UIFont.systemFont(ofSize: 12)
        return descLabel
    }()
    
    // 继承父类方法 布局
    override func setupLayout() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        iconView.layer.cornerRadius = 5
        iconView.layer.borderColor = UIColor.background.cgColor
        iconView.layer.borderWidth = 0.5
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    // 设置样式
    var cellStyle: ComicCollectionViewCellStyle = .withTitle {
        didSet {
            switch cellStyle {
            case .none:
                // 布局更新
                titleLabel.snp.updateConstraints{ make in
                    make.bottom.equalToSuperview().offset(25)
                }
                titleLabel.isHidden = true
                descLabel.isHidden = true
            case .withTitle:
                titleLabel.snp.updateConstraints{ make in
                    make.bottom.equalToSuperview().offset(-10)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = true
            case .withTitieAndDesc:
                titleLabel.snp.updateConstraints{ make in
                    make.bottom.equalToSuperview().offset(-25)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = false
            }
        }
    }
    
    
    var model: ItemModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover,
                                 placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.title ?? ""
            descLabel.text = model.subTitle ?? ""
        }
    }
    
    var bookModel: favModel? {
        didSet {
            guard let bookModel = bookModel else { return }
            
            if bookModel.cover == nil {
                iconView.image = UIImage(named: "addBookHead")
                titleLabel.text = "添加漫画"
                titleLabel.textAlignment = .center
                descLabel.text = ""
            } else {
                iconView.kf.setImage(urlString: bookModel.cover,
                                     placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
                titleLabel.text = bookModel.name ?? ""
                titleLabel.textAlignment = .left
                let leftStr = bookModel.last_read_chapter_name ?? "未读"
                let rightStr = bookModel.last_update_chapter_name ?? ""
                descLabel.text = leftStr + "/" + rightStr
            }
        }
    }

}
