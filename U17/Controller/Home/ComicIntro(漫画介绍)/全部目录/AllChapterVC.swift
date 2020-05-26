//
//  AllChapterVC.swift
//  U17
//
//  Created by lyw on 2020/5/22.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class AllChapterVC: BaseController {
    public var comicId: Int?
    private var isPositive: Bool = true
    // 漫画基本信息
    public var detailComic: ComicDetailModel?

    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    private var chapterList = [ChapterModel]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(UINib.init(nibName: "ChapterCell", bundle: Bundle.main), forCellReuseIdentifier: "ChapterCell")
        tableView.uempty = UEmptyView { [weak self] in self?.loadData() }

        loadData()
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData() {
        ApiProvider.request(Api.comicChapterList(comicid:comicId ?? 0), model: ChapterListModels.self) { (returnData) in
            self.chapterList = returnData?.chapter_list ?? []
            self.totalLb.text = "（共 \(self.chapterList.count) 话）"
            self.tableView.reloadData()
        }
    }
    
    @IBAction func reverseClick(_ sender: Any) {
        if self.chapterList.count > 0 {
            isPositive = !isPositive
            leftBtn.setTitleColor(isPositive ? .black:.lightGray, for: .normal)
            rightBtn.setTitleColor(isPositive ? .lightGray:.black, for: .normal)

            self.chapterList.reverse()
            self.tableView.reloadData()
        }
    }
    
}

extension AllChapterVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as! ChapterCell
        cell.model = chapterList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.chapterList.count > 0 {
            let vc = ReadComicVC(detailComic: self.detailComic, chapterList: chapterList, selectIndex: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
