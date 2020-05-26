//
//  HomeVC.swift
//  U17
//
//  Created by lyw on 2020/5/14.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class HomeVC: BaseController {

        
    // 模型
    private var galleryItems = [GalleryItems]()
    private var textItems = [TextItems]()
    private var modules = [Modules]()
    private var defaultSearch: String?
    
    private lazy var navView: FindNavView = {
        let navV = FindNavView()
        return navV
    }()

    private lazy var bannerView: LLCycleScrollView = {
        let cycleScrollView = LLCycleScrollView()
        cycleScrollView.backgroundColor = UIColor.background
        cycleScrollView.autoScrollTimeInterval = 6
        cycleScrollView.placeHolderImage = UIImage(named: "normal_placeholder_h")
        cycleScrollView.coverImage = UIImage(named: "normal_placeholder_h")
        cycleScrollView.pageControlBottom = 20
        cycleScrollView.titleBackgroundColor = UIColor.clear
        cycleScrollView.customPageControlStyle = .image
        cycleScrollView.pageControlPosition = .left
//        cycleScrollView.pageControlActiveImage = UIImage(named: "emojiCommunity")
        cycleScrollView.pageControlInActiveImage = UIImage(named: "finishobj")

        // 点击 item 回调
        cycleScrollView.lldidSelectItemAtIndex = didSelectBanner(index:)
        return cycleScrollView
    }()

    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: screenHeight/2.0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        // 注册cell
        collectionView.register(cellType: ComicCollectionViewCell.self)
        collectionView.register(cellType: BoardCollectionViewCell.self)
        // 注册头部 尾部
        collectionView.register(supplementaryViewType: ComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: ComicCollectionFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
        // 刷新控件
        collectionView.uHead = URefreshHeader { [weak self] in self?.setupLoadData() }
        collectionView.uFoot = URefreshDiscoverFooter()
        collectionView.uempty = UEmptyView(verticalOffset: -(collectionView.contentInset.top)) { self.setupLoadData() }
        return collectionView
    }()

    var style: UIStatusBarStyle = .lightContent
    
    // 重写statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadData()
    }
    
    private func didSelectBanner(index: NSInteger) {
        print("轮播图被点击了...")
        if galleryItems.count <= 0 { return }
        let item = galleryItems[index]
        if item.linkType == 3 {
            guard let comicId = item.ext?.first?.val else {
                return
            }
            
            let storyboard = UIStoryboard(name: "ComicIntroVC", bundle: nil)
            let cimicIntroVC = storyboard.instantiateViewController(withIdentifier: "ComicIntroVC") as! ComicIntroVC
            cimicIntroVC.comicId = Int(comicId)
            navigationController?.pushViewController(cimicIntroVC, animated: true)

        } else {
//            guard let url = item.ext?.compactMap({
//                return $0.key == "url" ? $0.val : nil
//            }).joined() else {
//                return
//            }
//            let vc = WebViewController(url: url)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func setupLoadData() {

        ApiLoadingProvider.request(Api.findHome, model: HomeDatasModel.self) { [weak self] (returnData) in
            self?.galleryItems = returnData?.galleryItems ?? []
            self?.textItems = returnData?.textItems ?? []
            self?.modules = returnData?.modules ?? []

            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true

            self?.collectionView.reloadData()
            self?.bannerView.bg_imagePaths = self?.galleryItems.filter { $0.topCover != nil }.map { $0.topCover! } ?? []
            self?.bannerView.imagePaths = self?.galleryItems.filter { $0.cover != nil }.map { $0.cover! } ?? []
            self?.defaultSearch = returnData?.defaultSearch
            self?.navView.defaultSearch = self?.defaultSearch
        }
    }

    // 继承了父类
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }

        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(collectionView.contentInset.top)
        }
        
        view.addSubview(navView)
        
        navView.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }

    }
}

extension HomeVC: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return modules.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = modules[section]
        return model.items?.count ?? 1
    }

    // 头尾视图
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: ComicCollectionHeaderView.self)
            let model = modules[indexPath.section]
            headerView.iconView.kf.setImage(urlString: model.moduleInfo?.icon)
            headerView.titleLabel.text = model.moduleInfo?.title
            headerView.moreActionClosure { [weak self] in
                
            }
            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: ComicCollectionFooterView.self)
            return footerView
        }
    }

    // 头部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50)
    }

    // 尾部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return modules.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = modules[indexPath.section]
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicCollectionViewCell.self)
        cell.model = model.items?[indexPath.row].first
        cell.cellStyle = .withTitieAndDesc
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = modules[indexPath.section]
        switch model.items!.count {
        case 4:
            let width = floor(Double(screenWidth - 30.0) / 2.0)
            return CGSize(width: width, height: width * 0.85)
        case 5:
            if indexPath.row == 0 {
                let width = floor(Double(screenWidth - 30.0) / 3.0)
                return CGSize(width: width * 2, height: width * 1.75)
            }
            let width = floor(Double(screenWidth - 30.0) / 3.0)
            return CGSize(width: width, height: width * 1.75)
        case 3, 6:
            let width = floor(Double(screenWidth - 30.0) / 3.0)
            return CGSize(width: width, height: width * 1.75)

        default:
            let width = floor(Double(screenWidth - 30.0) / 3.0)
            return CGSize(width: width, height: width * 1.75)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modules[indexPath.section]
        let comicModel = model.items?[indexPath.row].first
        let storyboard = UIStoryboard(name: "ComicIntroVC", bundle: nil)
        let cimicIntroVC = storyboard.instantiateViewController(withIdentifier: "ComicIntroVC") as! ComicIntroVC
        
        cimicIntroVC.comicId = comicModel?.comicId ?? 0
        navigationController?.pushViewController(cimicIntroVC, animated: true)
//        guard let item = model.comics?[indexPath.row] else { return }
//
//        if model.comicType == .billboard {
//            let vc = modelController(argName: item.argName,
//                                              argValue: item.argValue)
//            vc.title = item.name
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            if item.linkType == 2 {
//                guard let url = item.ext?.compactMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
//                let vc = WebController(url: url)
//                navigationController?.pushViewController(vc, animated: true)
//            } else {
//                let vc = ComicController(comicid: item.comicId)
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }

//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        if (segue.identifier == "ComicIntroVC") {
//            var detailVC = segue!.destinationViewController as ComicIntroVC;
//            detailVC.toPass = textField.text
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
        navView.value = scrollView.contentOffset.y
        if scrollView.contentOffset.y >= -200 {
            self.style = .default

        } else {
            self.style = .lightContent
        }
        setNeedsStatusBarAppearanceUpdate()
        
        if scrollView == collectionView {
            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5, animations: {

            })
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5, animations: {

            })
        }
    }
}
