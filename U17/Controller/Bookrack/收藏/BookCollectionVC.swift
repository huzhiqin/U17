//
//  BookCollectionVC.swift
//  U17
//
//  Created by lyw on 2020/5/15.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class BookCollectionVC: BaseController {

    // () 就是实例化相当于OC中的init
    private var collectList = [favModel]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewSectionBackgroundLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(cellType: ComicCollectionViewCell.self)
        collectionView.uHead = URefreshHeader{ [weak self] in self?.setupLoadData() }
        collectionView.uempty = UEmptyView { [weak self] in self?.setupLoadData() }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 加载数据
        setupLoadData()
    }
    
    private func setupLoadData() {
        ApiLoadingProvider.request(Api.myFav, model: favListModel.self) { (returnData) in
            
            self.collectionView.uHead.endRefreshing()
            self.collectionView.uempty?.allowShow = true
            
            self.collectList = returnData?.favList ?? []
            // 冒泡排序 把最近读过的排前面
            self.bubbleSort()
            // 添加一个默认ITEM，只响应点击
            self.collectList.append(favModel())
            self.collectionView.reloadData()
        }
    }
    
    override func setupLayout() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalTo(self.view).offset(90)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    func bubbleSort() {
        // 冒泡排序 把最近读过的排前面
        for i in 0..<self.collectList.count {
            for j in i+1..<self.collectList.count {
                let model_i: favModel? = self.collectList[i]
                let model_j: favModel? = self.collectList[j]
                let sort_i: Int = model_i?.sort ?? 0
                let sort_j: Int = model_j?.sort ?? 0
                if sort_i > sort_j {
                    let temp: favModel? = self.collectList[j]
                    self.collectList[j] = self.collectList[i]
                    self.collectList[i] = temp!
                }
            }
        }
    }
}

extension BookCollectionVC: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicCollectionViewCell.self)
        cell.cellStyle = .withTitieAndDesc
        cell.bookModel = collectList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: width * 1.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == collectList.count - 1 {
            // 点击最后一个 添加漫画
            self.tabBarController?.selectedIndex = 1
        }
//        let comicList = collectList[indexPath.section]
//        guard let model = comicList.comics?[indexPath.row] else { return }
//        let vc = ComicController(comicid: model.comicId)
//        navigationController?.pushViewController(vc, animated: true)
    }

}
