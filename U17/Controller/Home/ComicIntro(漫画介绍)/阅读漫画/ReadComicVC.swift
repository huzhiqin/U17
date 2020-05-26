//
//  ReadComicVC.swift
//  U17
//
//  Created by lyw on 2020/5/25.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class ReadComicVC: BaseController {

    private var isBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.topBar.snp.updateConstraints { make in
                    make.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgeInsets.top + 54) : 0)
                }
                self.bottomBar.snp.updateConstraints { make in
                    make.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (self.edgeInsets.bottom + 120) : 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    private var isLandscapeRight: Bool! {
        didSet {
            UIApplication.changeOrientationTo(landscapeRight: isLandscapeRight)
            collectionView.reloadData()
        }
    }
    
    // 每章漫画图片数据
    private var chapterImgList = [Image_list]()
    // 漫画基本信息
    private var detailComic: ComicDetailModel?
    // 所有章节数据
    private var chapterList = [ChapterModel]()

    private var selectIndex: Int = 0
    
    private var previousIndex: Int = 0
    
    private var nextIndex: Int = 0
    
    lazy var backScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        return scrollView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ReadCollectionViewCell.self)
        collectionView.uHead = URefreshAutoHeader { [weak self] in
            let previousIndex = self?.previousIndex ?? 0
            self?.loadData(with: previousIndex, isPreious: true, needClear: false, finished: { [weak self]  (finish) in
                self?.previousIndex = previousIndex - 1
            })
        }
        collectionView.uFoot = URefreshAutoFooter { [weak self] in
            let nextIndex = self?.nextIndex ?? 0
            self?.loadData(with: nextIndex, isPreious: false, needClear: false, finished: { [weak self]  (finish) in
                self?.nextIndex = nextIndex + 1
            })
        }
        return collectionView
    }()
    
    lazy var topBar: ReadTopBarView = {
        let topBar = ReadTopBarView()
        topBar.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        return topBar
    }()
    
    lazy var bottomBar: ReadBottomBarView = {
        let bottomBar = ReadBottomBarView()
        bottomBar.deviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        bottomBar.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return bottomBar
    }()
    
    convenience init(detailComic: ComicDetailModel?, chapterList: [ChapterModel]?, selectIndex: Int) {
        self.init()
        self.detailComic = detailComic
        self.chapterList = chapterList ?? []
        self.selectIndex = selectIndex
        self.previousIndex = selectIndex - 1
        self.nextIndex = selectIndex + 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isLandscapeRight = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .all
        loadData(with: selectIndex, isPreious: false, needClear: false)
    }
    
    func loadData(with index: Int, isPreious: Bool, needClear: Bool, finished: ((_ finished: Bool) -> Void)? = nil) {
        guard let detailComic = detailComic else { return }
        topBar.titleLabel.text = detailComic.comic?.name
        
        if index <= -1 {
            collectionView.uHead.endRefreshing()
            UNoticeBar(config: UNoticeBarConfig(title: "亲,这已经是第一页了")).show(duration: 2)
        } else if index > self.chapterList.count {
            collectionView.uFoot.endRefreshingWithNoMoreData()
            UNoticeBar(config: UNoticeBarConfig(title: "亲,已经木有了")).show(duration: 2)
        } else {
            guard let chapterId = self.chapterList[index].chapter_id else { return }
            ApiLoadingProvider.request(Api.chapter(chapter_id: chapterId), model: ReadComicModel.self) { (returnData) in
                
                self.collectionView.uHead.endRefreshing()
                self.collectionView.uFoot.endRefreshing()
                
                guard let comics = returnData?.image_list else {
                    let alertController = UIAlertController(title: "提示", message: "第[\(index+1)]话需要付费观看", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .default, handler: {(alerts:UIAlertAction) -> Void in
                        if self.chapterImgList.count <= 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                if needClear { self.chapterImgList.removeAll() }
                if isPreious {
                    self.chapterImgList.insert(contentsOf: comics, at: 0)
                } else {
                    self.chapterImgList.append(contentsOf: comics)
                }
                self.collectionView.reloadData()
                guard let finished = finished else { return }
                finished(true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLandscapeRight = false
    }
    
    @objc func tapAction() {
        isBarHidden = !isBarHidden
    }
    
    @objc func doubleTapAction() {
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width / 2 , y: backScrollView.center.y - height / 2, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
    }
    
    @objc func changeDeviceDirection(_ button: UIButton) {
        isLandscapeRight = !isLandscapeRight
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func changeChapter(_ button: UIButton) {
    }
    
    override func setupLayout() {
     
        view.backgroundColor = UIColor.white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { make in make.edges.equalTo(self.view.usnp.edges) }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(backScrollView)
            make.height.equalTo(54)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(backScrollView)
            make.height.equalTo(120)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.white)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_black"), target: self, action: #selector(pressBack))
        navigationController?.disablePopGesture = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return isIphoneX ? false : true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension ReadComicVC:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterImgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image: Image_list = chapterImgList[indexPath.row] else { return CGSize.zero }
        let width = backScrollView.frame.width
        let imgW = CGFloat((((image.width! ) as String) as NSString).floatValue)
        let imgH = CGFloat((((image.height! ) as String) as NSString).floatValue)

        let height = floor(width / imgW * imgH)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ReadCollectionViewCell.self)
        cell.model = chapterImgList[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false { isBarHidden = true }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        } else {
            return nil
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale, height: scrollView.frame.height)
        }
    }

}
