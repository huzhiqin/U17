//
//  ComicIntroVC.swift
//  U17
//
//  Created by lyw on 2020/5/18.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit
import MBProgressHUD

class ComicIntroVC: BaseController {
    public var comicId: Int = 0
    private var comicDetailModel: ComicDetailModel?
    private var chapterList = [ChapterModel]()

    private var comicModel: Comic?
    private var otherWorks: [OtherWorks]?

    @IBOutlet weak var scrollV: UIScrollView!

    @IBOutlet weak var toReadView: UIView!
    
    @IBOutlet weak var midView: UIView!

    @IBOutlet weak var btmView: UIView!
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var comicCover: UIImageView!
    @IBOutlet weak var coverBG: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var makerName: UILabel!
    @IBOutlet weak var tagBtn_1: UIButton!
    @IBOutlet weak var click_total_btn: UIButton!
    @IBOutlet weak var favorite_total_btn: UIButton!
    
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var pass_chapter_numLB: UILabel!
    @IBOutlet weak var chapter_lastNameLb: UILabel!
    @IBOutlet weak var lastTimeLb: UILabel!
    @IBOutlet weak var lastChapterCover: UIImageView!
    
    @IBOutlet weak var month_ticket: UILabel!
    @IBOutlet weak var month_giftLb: UILabel!
    
    
    @IBOutlet weak var authorView: UIView!
    @IBOutlet weak var authorImg: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var rewardBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var collectBtn: UIButton!
    
    @IBOutlet weak var scroll_con_height: NSLayoutConstraint!
//    @IBOutlet weak var btm_v_height: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        getDetailData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toReadAction))
        tap.numberOfTapsRequired = 1
        toReadView.addGestureRecognizer(tap)

    }
    
    @objc func toReadAction() {
        if self.chapterList.count > 0 {
            let vc = ReadComicVC(detailComic: self.comicDetailModel, chapterList: chapterList, selectIndex: self.comicDetailModel?.chapter_list?.first?.chapterIndex ?? 0)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func getDetailData() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        ApiLoadingProvider.request(Api.comicIntro(comicid: comicId), model: ComicDetailModel.self) { [weak self] (returnData) in
            self?.comicDetailModel = returnData
            
            dispatchGroup.leave()
            
        }
        
        dispatchGroup.enter()
        // 获取所有章节数据
        ApiProvider.request(Api.comicChapterList(comicid:comicId), model: ChapterListModels.self) { [weak self] (returnData) in
            self?.chapterList = returnData?.chapter_list ?? []
            
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            let comicModel = self.comicDetailModel?.comic
            self.comicModel = comicModel
            self.otherWorks = self.comicDetailModel?.otherWorks
            
            self.comicCover.kf.setImage(urlString: comicModel?.cover,
                                   placeholder:UIImage(named: "normal_placeholder_v"))
            self.coverBG.kf.setImage(urlString: comicModel?.wideCover,
                                   placeholder:UIImage(named: "normal_placeholder_h"))
            self.makerName.text = comicModel?.author?.name
            self.navTitle.text = comicModel?.name
            self.name.text = comicModel?.name
            self.tagBtn_1.setTitle(comicModel?.classifyTags?.first?.name, for: .normal)
            self.click_total_btn.setTitle(" 热度值 \(comicModel?.click_total ?? "")", for: .normal)
            let fav = comicModel?.favorite_total
            let favStr = " 收藏值 \(fav!)"
            self.favorite_total_btn.setTitle(favStr, for: .normal)
            
            self.descriptionLb.text = comicModel?.description
            self.pass_chapter_numLB.text = "（共 \(comicModel?.pass_chapter_num ?? 0) 话）"
            self.chapter_lastNameLb.text = "第 \(comicModel?.pass_chapter_num ?? 0) 话"
            let dateStr = getDateBytimeStamp(comicModel?.last_update_time ?? 0)
            self.lastTimeLb.text = "第 \(comicModel?.pass_chapter_num ?? 0) 话 \(dateStr)"
            self.lastChapterCover.kf.setImage(urlString: comicModel?.wideCover,
                                   placeholder:UIImage(named: "normal_placeholder_h"))
            
            self.month_ticket.text = comicModel?.month_ticket
            self.month_giftLb.text = "\(comicModel?.month_gift ?? 0)"

            self.authorImg.kf.setImage(urlString: comicModel?.author?.avatar,
                                   placeholder:UIImage(named: "sortPlace"))
            self.authorName.text = comicModel?.author?.name

            
//            let height = self?.descriptionLb.sizeThatFits(CGSize(width: screenWidth - 20, height: CGFloat.infinity)).height

        }

    }
    
    @IBAction func closeClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupShapLayer(_ v: UIView) {
        let shapLayer = CAShapeLayer()
        let cornersRadius = CCornersRadius(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0)
        shapLayer.path = v.createPath(bounds: v.bounds, cornersRadius: cornersRadius)
        v.layer.mask = shapLayer
    }
    
    override func setupLayout() {
        setupShapLayer(midView)
        setupShapLayer(btmView)
        
        scrollV.layer.cornerRadius = 10

        comicCover.layer.cornerRadius = 10
        comicCover.layer.borderColor = UIColor.white.cgColor
        comicCover.layer.borderWidth = 2.0
        
        tagBtn_1.layer.cornerRadius = 14
        tagBtn_1.layer.borderColor = UIColor.white.cgColor
        tagBtn_1.layer.borderWidth = 1.0

        lastChapterCover.layer.cornerRadius = 10
        authorImg.layer.cornerRadius = authorImg.frame.size.width/2

        rewardBtn.imagePosition(style: .top, spacing: 0)
        commentBtn.imagePosition(style: .top, spacing: 0)
        collectBtn.imagePosition(style: .top, spacing: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(vTap(tap:)))
        scrollV.addGestureRecognizer(tapGesture)

        let tapAuthor = UITapGestureRecognizer(target: self, action: #selector(toOtherWorksVC))
        authorView.addGestureRecognizer(tapAuthor)

    }
    
    // 单击手势
    @objc func vTap(tap: UITapGestureRecognizer) {
        var point = tap.location(in: tap.view)
        point.y += scrollV.frame.origin.y
//        print("point", point)
        
        if tagBtn_1.frame.contains(point) {
            print("【\(tagBtn_1.currentTitle!)】被点击了")
        }
    }
    
    @IBAction func allChaptersClick(_ sender: Any) {
        // 全部目录
        let storyboard = UIStoryboard(name: "AllChapterVC", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "AllChapterVC") as! AllChapterVC
        VC.comicId = comicId
        VC.detailComic = self.comicDetailModel
        let nav: NaviController = NaviController.init(rootViewController: VC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func toOtherWorksVC() {
        // 进入作者全部作品
        guard (otherWorks?.count) != 0 else {
            let alertController = UIAlertController(title: "提示", message: "该作者没有更多其它作品", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let authorVC = AuthorComicListVC(author: comicModel?.author, otherWorks: otherWorks)
        navigationController?.pushViewController(authorVC, animated: true)
    }
    
    @IBAction func readComicClick(_ sender: Any) {
        if self.chapterList.count > 0 {
            let vc = ReadComicVC(detailComic: self.comicDetailModel, chapterList: chapterList, selectIndex: 0)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

