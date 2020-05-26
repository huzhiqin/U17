//
//  ReadBottomBarView.swift
//  U17
//
//  Created by lyw on 2020/5/25.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit
import SnapKitExtend

class ReadBottomBarView: UIView {

    lazy var menuSlider: UISlider = {
        let menuSlider = UISlider()
        menuSlider.thumbTintColor = UIColor.theme
        menuSlider.minimumTrackTintColor = UIColor.theme
        menuSlider.setThumbImage(UIImage(named: "readerMenu_scrollPageThumb"), for: .normal)
        
        menuSlider.isContinuous = false
        return menuSlider
    }()
    
    lazy var deviceDirectionButton: UIButton = {
        let deviceDirectionButton = UIButton(type: .system)
        deviceDirectionButton.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return deviceDirectionButton
    }()
        
    lazy var chapterButton: UIButton = {
        let chapterButton = UIButton(type: .system)
        chapterButton.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return chapterButton
    }()
    
    lazy var settignButton: UIButton = {
        let settignButton = UIButton(type: .system)
        settignButton.setImage(UIImage(named: "readerMenu_setting")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return settignButton
    }()

    lazy var tucaoButton: UIButton = {
        let tucaoButton = UIButton(type: .system)
        tucaoButton.setImage(UIImage(named: "readerMenu_tucao")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return tucaoButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let blurEffect = UIBlurEffect(style: .dark)
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurView.contentView.addSubview(menuSlider)
        menuSlider.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            make.height.equalTo(30)
            
        }
        
        blurView.contentView.addSubview(deviceDirectionButton)
        blurView.contentView.addSubview(chapterButton)
        blurView.contentView.addSubview(settignButton)
        blurView.contentView.addSubview(tucaoButton)

        let buttonArray = [deviceDirectionButton, chapterButton, settignButton, tucaoButton]
        buttonArray.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 60, leadSpacing: 20, tailSpacing: 20)
        buttonArray.snp.makeConstraints { make in
            make.top.equalTo(menuSlider.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}
