//
//  MineVC.swift
//  U17
//
//  Created by lyw on 2020/5/14.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class MineVC: BaseController {
    private let headHeight: CGFloat = 300
    
    private lazy var titleArray: Array = {
        return [["icon":"sep_register", "title": "签到"],
                ["icon":"sep_mywallet", "title": "钱包"],
                ["icon":"sep_subscription", "title": "订阅"],
                ["icon":"sep_fengyintu", "title": "封印图"],
                ["icon":"sep_theme", "title": "皮肤"],
                ["icon":"myvotebiao", "title": "我的投票"],
                ["icon":"sep_help", "title": "帮助反馈"],
                ["icon":"sep_beijing", "title": "首都网警"],
                ["icon":"sep_auther", "title": "作者中心"],
                ["icon":"sep_setting", "title": "设置"]]
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumInteritemSpacing = 10
        lt.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        return collectionView

    }()
    
    private lazy var head: MineHeaderView = {
        return MineHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headHeight))
    }()

    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {(make) in
            make.edges.equalTo(self.view.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }

        collectionView.register(cellType: MineCollectionViewCell.self)
        collectionView.parallaxHeader.view = head
        collectionView.parallaxHeader.height = headHeight
        collectionView.parallaxHeader.minimumHeight = navigationBarY
        collectionView.parallaxHeader.mode = .fill
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        collectionView.contentOffset = CGPoint(x: 0, y: -collectionView.parallaxHeader.height)
    }
}

extension MineVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(scrollView.parallaxHeader.minimumHeight) {
            navigationController?.barStyle(.theme)
            navigationItem.title = "我的"
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MineCollectionViewCell.self)
        cell.dict = titleArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: (width * 0.75 + 30))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

    }

}
